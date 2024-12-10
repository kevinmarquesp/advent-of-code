defmodule Puzzle do
  @moduledoc """
  Lists all positions (row and column indexes) where a 0 can be found. The runs
  the trailheads algorithm for each position, resulting in a bunch of lists with
  the possible destinations (each should be a 9 in the grid).

  Not all that information is relevant, so to solve it needs to filter the
  repeated positions for each result (I want to count the destinations and not
  all possibilies for destinations). Finally, take the length for each result
  and sum it all up to get the answer.
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
      |> Enum.uniq()
      |> length()
    end)
    |> Enum.sum()
  end
end
