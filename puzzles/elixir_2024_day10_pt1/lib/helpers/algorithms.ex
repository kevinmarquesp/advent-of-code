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

  @doc "Given a position, it'll return a list with the valid surounding positions."
  def next_adjacent([], _, _), do: []

  def next_adjacent(grid, {row, col}, {max_row, max_col}) do
    [
      # {row - 1, col - 1},
      {row - 1, col},
      # {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      # {row + 1, col - 1},
      {row + 1, col}
      # {row + 1, col + 1}
    ]
    |> Enum.filter(fn {r, c} ->
      r <= max_row and r >= 0 and
        c <= max_col and c >= 0 and
        grid_at(grid, {r, c}) == grid_at(grid, {row, col}) + 1
    end)
  end

  @doc "Returns a list of the positions of the 9's that can be traced to."
  def find_trailheads(grid, {row, col}, boundaries) do
    if grid_at(grid, {row, col}) == 9 do
      [{row, col}]
    else
      next_adjacent(grid, {row, col}, boundaries)
      |> Stream.flat_map(&find_trailheads(grid, &1, boundaries))
    end
  end
end
