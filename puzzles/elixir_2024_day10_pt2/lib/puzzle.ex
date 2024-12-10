defmodule Puzzle do
  @moduledoc """
  Find the 0's positions and apply the trailheads algorithm for each of them.
  The results for that algorithm should be a list of 9's positions, where if the
  repeated positions indicate that the provided starter position has multiple
  paths for the same destination (the cells with the number 9).

  Take the length of those results to get the total paths to a 9 that each 0
  position has, the answer should be the sum of those values.
  """

  alias Puzzle.Helpers.Algorithms

  @doc "Parses the raw file content string to a list/tuple before solving it."
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
      # This map is necessary because of a performance implementation...
      |> Enum.map(& &1)
      |> length()
    end)
    |> Enum.sum()
  end
end
