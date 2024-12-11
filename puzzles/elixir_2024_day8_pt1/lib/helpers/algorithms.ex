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

  @doc "Giving two antennas postions, it will return the antinode postion for them."
  def antinode({row, col}, {ref_row, ref_col}) do
    {dist_row, dist_col} =
      {row - ref_row, col - ref_col}

    {row + dist_row, col + dist_col}
  end
end
