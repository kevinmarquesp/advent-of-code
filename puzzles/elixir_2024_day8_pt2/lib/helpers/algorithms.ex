defmodule Puzzle.Helpers.Algorithms do
  @moduledoc """
  Algorithms needed to solve the puzzle that was separated from the main Puzzle
  package because thet `Puzzle.solve/1` would become too big and confusing.
  """

  @doc "Soimple helper to get a value from a 2D matrix by it's XY coordenates."
  def grid_at(grid, {row, col}) do
    Enum.at(grid, row)
    |> Enum.at(col)
  end

  @doc "Returns all antinodes positions, including the two antenna ones."
  def antinodes(:outside, base = {row, col}, {ref_row, ref_col}, bounds = {max_row, max_col}) do
    {dist_row, dist_col} =
      {row - ref_row, col - ref_col}

    {anti_row, anti_col} =
      {row + dist_row, col + dist_col}

    if anti_row < 0 or anti_row > max_row or
         anti_col < 0 or anti_col > max_col do
      []
    else
      [{anti_row, anti_col}] ++ antinodes(:outside, {anti_row, anti_col}, base, bounds)
    end
  end

  def antinodes(base, reff, bounds) do
    [base, reff] ++ antinodes(:outside, base, reff, bounds)
  end
end
