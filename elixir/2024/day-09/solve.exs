#!/usr/bin/env elixir

defmodule Solve do
  @doc """
  Generates the alternating lists then transform it to the correct one to get the checksum.
  """
  def solve(input) when is_bitstring(input) do
    String.split(input, "")
    |> Enum.filter(&(&1 !== ""))
    |> Enum.map(&String.to_integer/1)
    |> solve()
  end

  def solve(input) when is_list(input) do
    # Alternates between empty block and filled block while tracking the id.
    {_, _, blocks} =
      Enum.reduce(input, {false, 0, []}, fn
        size, {true, id, acc} ->
          {false, id, acc ++ List.duplicate(nil, size)}

        size, {false, id, acc} ->
          {true, id + 1, acc ++ List.duplicate(id, size)}
      end)

    compressed_size = length(blocks) - Enum.frequencies(blocks)[nil] - 1

    # Generate the compressed list with the expected size.
    compressed =
      0..compressed_size
      |> Enum.reduce(blocks, fn idx, acc ->
        if Enum.at(blocks, idx) === nil do
          # Get the last non nil index.
          last_idx =
            (Enum.reverse(acc)
             |> Enum.find_index(&(&1 !== nil))) * -1 - 1

          last = Enum.at(acc, last_idx)

          # Now uses a list with those values swaped.
          List.replace_at(acc, idx, last)
          |> List.replace_at(last_idx, nil)
        else
          acc
        end
      end)
      |> Enum.filter(&(&1 !== nil))

    0..compressed_size
    |> Enum.reduce(0, fn idx, acc ->
      acc + idx * Enum.at(compressed, idx)
    end)
  end
end

# Boilerplate to open the file in the CLI arguments.

if length(System.argv()) === 0 do
  raise "Provide a input text file to run this solution"
end

{:ok, data} =
  System.argv()
  |> Enum.at(0)
  |> File.read()

String.trim(data)
|> Solve.solve()
|> IO.puts()
