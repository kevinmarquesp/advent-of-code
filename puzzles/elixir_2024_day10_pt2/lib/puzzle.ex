defmodule Puzzle do
  @moduledoc """
  TODO: Describe your logic to solve this puzzle, you know, it's fun to share!
  """

  alias Puzzle.Helpers.Algorithms

  @doc """
  Parses the input file's content to a struct that Elixir can work with before
  doing the steps to solve it.
  """
  def solve(raw) when is_bitstring(raw) do
    String.split(raw, "\n")
    |> Enum.map(fn line ->
      String.codepoints(line)
      |> Enum.map(&String.to_integer/1)
    end)
    |> solve()
  end

  def solve(grid) do
    {max_row, max_col} = {length(grid) - 1, length(Enum.at(grid, 0)) - 1}

    # Get all 0 positions to start counting the trailheads scores.
    for row <- 0..max_row,
        col <- 0..max_col,
        Algorithms.grid_at(grid, {row, col}) == 0 do
      {row, col}
    end
    |> Enum.map(fn pos ->
      Algorithms.find_trailheads(grid, pos, {max_row, max_col})
      |> Enum.map(& &1)
      |> length()
    end)
    |> Enum.sum()
  end
end
