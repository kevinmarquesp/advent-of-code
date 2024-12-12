defmodule Puzzle do
  @moduledoc """
  **Day 8, 2024**

  I started by extracting the antennas positions lists, then for each antenna
  group positions, I generated a list with all the possible pair for that
  particular antennas group, then for each pair I ran the
  `Algorithms.antinodes/3` to get the antinodes positions. Then I repeated that
  same process with the other antenna groups.

  I endup with a massive multidimensional list, so I flatern it and filter the
  repeated antinode positions, because the puzzle wants only the unique count.
  Got the lenght of that array and it should be the answer.
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

  def solve(antennas_groups, bounds) do
    Enum.flat_map(antennas_groups, fn antennas ->
      for p1 <- antennas, p2 <- antennas, p1 != p2 do
        {p1, p2}
      end
      |> Enum.map(fn {coord, ref_coord} ->
        Algorithms.antinodes(coord, ref_coord, bounds)
      end)
      |> Enum.flat_map(& &1)
    end)
    |> Enum.uniq()
    |> length()
  end
end
