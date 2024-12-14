defmodule Puzzle.Core.Logic do
  @moduledoc """
  Abstracted algorithm functions to avoid making the `Puzzle.solve/1` function
  too big and complext.
  """

  @doc "Gets the relative position for each coordinate in a region."
  def perimeter(region) do
    Enum.flat_map(region, fn {row, col} ->
      [{row - 1, col}, {row, col - 1}, {row, col + 1}, {row + 1, col}]
      |> Enum.filter(&(&1 not in region))
    end)
  end

  @doc "Returns a list of coordinates that represents the desired region."
  def region(grid, plant, {row, col}, bounds, visited \\ []) do
    grid_neighbors({row, col}, bounds)
    |> Enum.filter(&(grid_at(grid, elem(&1, 0), elem(&1, 1)) == plant))
    |> Enum.filter(&(&1 not in visited))
    |> Enum.reduce([{row, col}] ++ visited, fn nextcoord, acc ->
      acc ++ region(grid, plant, nextcoord, bounds, acc)
    end)
    |> Enum.uniq()
  end

  # Enum related functions.

  @doc "Chunks a list by a increasing value withing the list (better when sorted)."
  def chunk_freq([], _), do: []
  def chunk_freq([elem], _), do: [[elem]]

  def chunk_freq(list, by) do
    Enum.chunk_while(
      list,
      [],
      fn elem, acc ->
        case acc do
          [] ->
            {:cont, [elem]}

          _ ->
            if by.(elem) == (hd(acc) |> by.()) + 1 do
              {:cont, [elem | acc]}
            else
              {:cont, Enum.reverse(acc), [elem]}
            end
        end
      end,
      fn acc -> {:cont, Enum.reverse(acc), []} end
    )
  end

  # Grid related functions.

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
