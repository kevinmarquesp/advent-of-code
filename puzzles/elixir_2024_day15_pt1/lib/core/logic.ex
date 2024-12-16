defmodule Puzzle.Core.Logic do
  @moduledoc """
  Abstracted algorithm functions to avoid making the `Puzzle.solve/1` function
  too big and complext.
  """

  @doc "Returns the next state for the boxes map."
  def move({row, col}, direction, bounds, boxes, walls) do
    nextcoord =
      case direction do
        :up -> {row - 1, col}
        :right -> {row, col + 1}
        :down -> {row + 1, col}
        :left -> {row, col - 1}
      end

    cond do
      not grid_within_bounds?(nextcoord, bounds) ->
        {:out, nextcoord}

      nextcoord in walls ->
        {:wall, nextcoord, boxes}

      nextcoord in boxes ->
        case move(nextcoord, direction, bounds, Enum.filter(boxes, &(&1 != nextcoord)), walls) do
          {:ok, newbox, updatedboxes} ->
            {:ok, nextcoord, [newbox] ++ updatedboxes}

          _ ->
            {:stop, nextcoord, boxes}
        end

      true ->
        {:ok, nextcoord, boxes}
    end
  end

  @doc "Simple helper to get a value from a 2D matrix by it's XY coordinates."
  def grid_at(grid, row, col) do
    Enum.at(grid, row)
    |> Enum.at(col)
  end

  @doc "Checks if a coordinate is inside the expected grid boundaries."
  def grid_within_bounds?({row, col}, {maxrow, maxcol}) do
    row >= 0 and row <= maxrow and
      col >= 0 and col <= maxcol
  end

  @doc "Returns the positions around a start coordinate that's within bounds."
  def grid_neighbors(start, bounds), do: grid_neighbors(start, bounds, diagonal: false)

  def grid_neighbors({row, col}, bounds, diagonal: false) do
    [
      {row - 1, col},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col}
    ]
    |> Enum.filter(&grid_within_bounds?(&1, bounds))
    |> Enum.sort()
  end

  def grid_neighbors({row, col}, bounds, diagonal: true) do
    [
      {row - 1, col - 1},
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1}
    ]
    |> Enum.filter(&grid_within_bounds?(&1, bounds))
    |> Enum.sort()
  end
end
