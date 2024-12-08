#!/usr/bin/env elixir

defmodule Solution do
  @doc """
  Uses the cartesian product algorithm to filter the valid ones then sum the values.
  """
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

  def solve(input) when is_list(input) do
    Enum.filter(input, fn {value, nums} ->
      IO.inspect({value, nums}, label: "Debug", charlists: :as_lists)

      is_valid?(value, nums)
    end)
    |> Enum.reduce(0, fn {value, _}, acc -> acc + value end)

    # |> IO.inspect(label: "Debug", charlists: :as_lists)
  end

  @doc """
  Place all operation combinations to calculate, return true if it equals the value.
  """
  def is_valid?(value, [head | tail] = nums) do
    List.duplicate([&+/2, &*/2], length(nums) - 1)
    |> product()
    |> Enum.reduce_while(nil, fn operators, _ ->
      calc =
        Enum.zip(operators, tail)
        |> Enum.reduce(head, fn {opr, num}, acc ->
          opr.(acc, num)
        end)

      if calc === value do
        {:halt, true}
      else
        {:cont, false}
      end
    end)
  end

  @doc """
  Returns the cartesian product matrix given a 2D matrix of any type/length.
  Adpated from: https://elixirforum.com/t/taking-cross-products-of-two-or-more-lists/35631
  """
  def product([head]), do: Enum.map(head, &[&1])

  def product([head | tail]) do
    for first <- head, b <- product(tail) do
      [first | b]
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
