defmodule Puzzle do
  @moduledoc """
  That was simple, I just created a function to get the next stones given a
  single stone number then I applyed that logic for each element of the initial
  list - since this function returns a list, I needed to use a flat map for
  that. Then I repeated it 25 times to get the final result.
  """

  alias Puzzle.Helpers.Algorithms

  @doc "Parses the raw file content string to a list/tuple before solving it."
  def solve(raw) when is_bitstring(raw) do
    String.split(raw, " ")
    |> Enum.map(&String.to_integer/1)
    |> solve()
  end

  def solve(stones) do
    for _ <- 1..25, reduce: stones do
      acc -> Enum.flat_map(acc, &Algorithms.next_stones/1)
    end
    |> length()
  end
end
