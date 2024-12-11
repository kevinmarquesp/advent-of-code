defmodule Puzzle do
  @moduledoc """
  Starts by getting all the antenna positions and their types from the input
  grid, group this list by the antenna characters, resulting in a list of
  lists of antenna positions (the actual antena type is not need anymore).

  With this 2D matrix of coordenates, it just needs to generate all the
  possible combinations of antenna coordenates for each antenna group, get
  the antinode[^1] coordenate for each pair, remove the out of bounds results,
  remove the repeated ones (because the puzzle only needs the unique antinode
  coordenates) and, finally, getting the ammount of antinodes in that list
  result.

  [^1]: That's pretty simple, given two coordenates, get the distance between
  them (not the absolute distance, the negative values is important) and sum
  this XY results with the first coordenate given.
  """

  alias Puzzle.Helpers.Algorithms

  @doc "Parses the raw file content string to a list/tuple before solving it."
  def solve(raw) when is_bitstring(raw) do
    grid =
      String.split(raw, "\n")
      |> Enum.map(&String.codepoints/1)

    {max_row, max_col} = {length(grid) - 1, (Enum.at(grid, 0) |> length()) - 1}

    for row <- 0..max_row,
        col <- 0..max_col,
        (antenna = Algorithms.grid_at(grid, {row, col})) != "." do
      {antenna, {row, col}}
    end
    |> Enum.sort()
    |> Enum.chunk_by(fn {antenna, _} -> antenna end)
    |> Enum.map(fn antennas -> Enum.map(antennas, &elem(&1, 1)) end)
    |> solve({max_row, max_col})
  end

  def solve(antennas_groups, {max_row, max_col}) do
    Enum.flat_map(antennas_groups, fn antennas ->
      for p1 <- antennas, p2 <- antennas, p1 != p2 do
        {p1, p2}
      end
    end)
    |> Enum.map(fn {coord, ref_coord} -> Algorithms.antinode(coord, ref_coord) end)
    |> Enum.filter(fn {row, col} ->
      row >= 0 and row <= max_row and
        col >= 0 and col <= max_col
    end)
    |> Enum.uniq()
    |> length()
  end
end
