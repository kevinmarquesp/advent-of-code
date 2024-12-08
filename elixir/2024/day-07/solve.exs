#!/usr/bin/env elixir

defmodule Solution do
  def solve(input) when is_bitstring(input) do
    String.split(input, "\n")
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [target_str, nums_str] ->
      {
        String.to_integer(target_str),
        String.split(nums_str, " ")
        |> Enum.map(&String.to_integer/1)
      }
    end)
    |> solve()
  end

  @doc """
  Uses multiple proccess to count only the valid lines (filter then reduce).
  """
  def solve(input) when is_list(input) do
    input
    |> Task.async_stream(
      &is_equation_valid?/1,
      max_concurrency: System.schedulers_online(),
      timeout: :infinity
    )
    |> Enum.filter(fn {:ok, {_, result}} -> result end)
    |> Enum.reduce(0, fn {:ok, {num, _}}, acc -> acc + num end)
  end

  @doc """
  Iterate over each operation combinations to check if it's valid
  """
  def is_equation_valid?({target, nums}) do
    IO.inspect({target, nums})

    # Start by iterating over each incremental combos.
    incremental_combinations(&+/2, &*/2, length(nums) - 1)
    |> Enum.reduce_while(nil, fn ops_comb, _ ->
      # Now get all unique positions that this increment combo can have.
      next_action =
        permutations(ops_comb)
        |> Enum.reduce_while(nil, fn ops, _ ->
          if apply_operations(nums, ops) === target do
            {:halt, :halt}
          else
            {:cont, :cont}
          end
        end)

      # If the previous reduce_while halts, it means that it is valid!
      {next_action, {target, next_action === :halt}}
    end)
  end

  @doc """
  Giving a list of numbers and another of operations, reduce the result of them.
  """
  def apply_operations([first | rest], ops) do
    Enum.zip(ops, rest)
    |> Enum.reduce(first, fn {op, num}, acc ->
      op.(acc, num)
    end)
  end

  @doc """
  """
  def incremental_combinations(main, alt, 1), do: [[main], [alt]]

  def incremental_combinations(main, alt, size) do
    0..size
    |> Enum.map(fn ammount ->
      List.duplicate(alt, ammount) ++ List.duplicate(main, size - ammount)
    end)
  end

  @doc """
  Elixir hack to get all possible permutations givin an enumerable.
  """
  def permutations([]), do: [[]]

  def permutations(list) do
    for elem <- list, rest <- permutations(list -- [elem]), uniq: true do
      [elem | rest]
    end
  end
end

# Boilerplate to open the file in the CLI arguments.

if System.argv() |> length() === 0 do
  raise "Provide a input text file to run this solution"
end

{:ok, data} =
  System.argv()
  |> Enum.at(0)
  |> File.read()

String.trim(data)
|> Solution.solve()
|> IO.puts()
