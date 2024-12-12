defmodule Puzzle do
  @moduledoc """
  **2024, day 12**: I think my abstraction capabilities is improving, I started
  by creating a function to get a region of a specific plant in the garden's
  grid - which is just a list of positions - and other to get the perimeter of
  a region - which is also a list of relative positions.

  The main solution logic was a matter of getting all regions of the grid
  (ignoring the positions where the plant was already present in the cache)
  and then getting the perimeters length for each region, I kept track of the
  length of the region as well in that proccess. Multiplyed thoses two values,
  got the sum of all elements in this final list and BAM, the result is there!
  """

  alias Puzzle.Core.Cache
  alias Puzzle.Core.Logic

  @doc "Parses the text file into a simple grid of strings before solving it."
  def solve(input) do
    grid = parse(input)

    {maxrow, maxcol} =
      bounds = {length(grid) - 1, (Enum.at(grid, 0) |> length()) - 1}

    Cache.start_link()

    # Iterates over the garden to get each plant region coordinates.
    for row <- 0..maxrow, col <- 0..maxcol do
      plant = Logic.grid_at(grid, row, col)

      # Create a new region or return [] if it was already registered.
      case Cache.get(plant) do
        :noindex ->
          region =
            Logic.region(grid, plant, {row, col}, bounds)
            |> Enum.sort()

          Cache.put(plant, [region])

          region

        regions ->
          if {row, col} in List.flatten(regions) do
            []
          else
            new_region =
              Logic.region(grid, plant, {row, col}, bounds)
              |> Enum.sort()

            Cache.put(plant, regions ++ new_region)

            new_region
          end
      end
    end
    |> Enum.filter(&(&1 != []))
    # Now get the region length times the perimeter length for each region.
    |> Enum.map(fn region ->
      length(region) *
        (Logic.perimeter(region)
         |> length())
    end)
    # The sum of this final list should be the puzzle's answer.
    |> Enum.sum()
  end

  defp parse(input) do
    String.split(input, "\n")
    |> Enum.map(&String.codepoints/1)
  end
end
