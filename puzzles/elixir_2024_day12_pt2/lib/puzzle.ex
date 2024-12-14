defmodule Puzzle do
  @moduledoc """
  **2024, day 12 (part 2)**: I spend two whole days to figure out that what I
  needed to do to count the sides was start by getting only the coordinates
  above and below each line, remove remove the coordinates that's already
  present in the current region and chunk those border where the column
  sequence is broken, this will result in the total sides of this row. Then I
  applyed this same algorithm to each line to got a list which it's length is
  the north/south sides of my region.

  Then it was a matter to apply that same logic with the columns instead (now
  only counting the left and right sides and chunking when the rows frequency
  is broken) and sum this with the rows sides length to get the total length.
  The rest is the rest, that was the main problem to be solved.
  """

  alias Puzzle.Core.Cache
  alias Puzzle.Core.Logic

  @doc "Parses the text file into a simple grid of strings before solving it."
  def solve(input) do
    grid = parse(input)

    {maxrow, maxcol} =
      bounds = {length(grid) - 1, (Enum.at(grid, 0) |> length()) - 1}

    Cache.start_link()

    for row <- 0..maxrow, col <- 0..maxcol do
      plant = Logic.grid_at(grid, row, col)

      if {row, col} in (([regions] = [Cache.get(plant)])
                        |> List.flatten()) do
        nil
      else
        region =
          Logic.region(grid, plant, {row, col}, bounds)
          |> Enum.sort()

        if :noindex == regions,
          do: Cache.put(plant, [region]),
          else: Cache.put(plant, regions ++ [region])

        region
      end
    end
    |> Enum.filter(&(&1 != nil))
    |> Enum.map(fn region ->
      row_sides =
        Enum.sort_by(region, &elem(&1, 0))
        |> Enum.chunk_by(&elem(&1, 0))
        |> Enum.map(fn line ->
          above =
            Enum.map(line, fn {row, col} -> {row - 1, col} end)
            |> Enum.filter(&(&1 not in region))
            |> Logic.chunk_freq(&elem(&1, 1))
            |> length()

          below =
            Enum.map(line, fn {row, col} -> {row + 1, col} end)
            |> Enum.filter(&(&1 not in region))
            |> Logic.chunk_freq(&elem(&1, 1))
            |> length()

          above + below
        end)
        |> Enum.sum()

      col_sides =
        Enum.sort_by(region, &elem(&1, 1))
        |> Enum.chunk_by(&elem(&1, 1))
        |> Enum.map(fn line ->
          left =
            Enum.map(line, fn {row, col} -> {row, col - 1} end)
            |> Enum.filter(&(&1 not in region))
            |> Logic.chunk_freq(&elem(&1, 0))
            |> length()

          right =
            Enum.map(line, fn {row, col} -> {row, col + 1} end)
            |> Enum.filter(&(&1 not in region))
            |> Logic.chunk_freq(&elem(&1, 0))
            |> length()

          left + right
        end)
        |> Enum.sum()

      (row_sides + col_sides) * length(region)
    end)
    |> Enum.sum()
  end

  defp parse(input) do
    String.split(input, "\n")
    |> Enum.map(&String.codepoints/1)
  end
end
