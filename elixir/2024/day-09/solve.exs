#!/usr/bin/env elixir

defmodule Solve do
  @doc """
  Convert to sequency frequency then parse it all to calculate the result.
  """
  def solve(input) when is_bitstring(input) do
    String.split(input, "")
    |> Enum.filter(&(&1 !== ""))
    |> Enum.map(&String.to_integer/1)
    |> solve()
  end

  def solve(input) when is_list(input) do
    {_, _, blocks} =
      Enum.reduce(input, {false, 0, []}, fn
        size, {true, id, acc} ->
          {false, id, acc ++ [{:empty, nil, size}]}

        size, {false, id, acc} ->
          {true, id + 1, acc ++ [{:movable, id, size}]}
      end)

    compress_blocks(blocks)
    |> Enum.flat_map(fn {_, data, size} -> List.duplicate(data, size) end)
    |> Enum.reduce({0, 0}, fn
      nil, {idx, res} -> {idx + 1, res}
      num, {idx, res} -> {idx + 1, res + idx * num}
    end)
    |> elem(1)
  end

  @doc """
  Uses recursion to move the end files to the free space blocks.
  """
  def compress_blocks(blocks) do
    {files, spaces} =
      Enum.zip(0..(length(blocks) - 1), blocks)
      |> Enum.reduce({[], []}, fn
        {idx, {:empty, nil, space}}, {files, spaces} ->
          {files, spaces ++ [{idx, :empty, nil, space}]}

        {idx, {:movable, file, size}}, {files, spaces} ->
          {files ++ [{idx, :movable, file, size}], spaces}

        _, acc ->
          acc
      end)

    updated =
      Enum.reverse(files)
      |> Enum.reduce_while(nil, fn {file_idx, :movable, file, size}, _ ->
        case find_space_block(spaces, size) do
          {space_idx, :empty, nil, space} ->
            debug({file_idx, :movable, file, size})

            if file_idx > space_idx do
              {
                :halt,
                List.replace_at(blocks, file_idx, {:empty, nil, size})
                |> List.replace_at(space_idx, [{:fixed, file, size}, {:empty, nil, space - size}])
                |> List.flatten()
              }
            else
              {:cont, blocks}
            end

          nil ->
            {:cont, blocks}
        end
      end)

    if updated === blocks do
      updated
    else
      compress_blocks(updated)
    end
  end

  defp find_space_block(spaces, size) do
    Enum.find(spaces, fn
      {_, :empty, nil, space} -> space >= size
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
