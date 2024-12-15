defmodule Puzzle do
  @moduledoc """
  **2024, day 14 (part 1)**: I think this one was the esiest one until now. The
  main logic was to take the remainder of the multiplication of each coordinate
  with its velocity and then fixing some negative values, I wanted to use only
  the positve ones, not out-of-bounds allowed here.

  Then I created a simple array with all the quadrants start and end positions
  for the rows and columns. The last step was to make each quadrant filter the
  robots coordinates by the ones that's present on the current quadrant and
  get the length of each quadrant (which will tell how much robots are there).
  The answer should be the product of all elements in this final list.
  """

  @doc "Uses a list of tuples with two tuples, a coordinate and a velocity."
  def solve(input, {endrow, endcol} \\ {103, 101}, seconds \\ 100) do
    robots = parse(input)

    coords =
      Enum.map(robots, fn {{row, col}, {velrow, velcol}} ->
        {if((newrow = rem(row + velrow * seconds, endrow)) < 0, do: endrow + newrow, else: newrow),
         if((newcol = rem(col + velcol * seconds, endcol)) < 0, do: endcol + newcol, else: newcol)}
      end)

    [
      {{0, floor(endrow / 2) - 1}, {0, floor(endcol / 2) - 1}},
      {{0, floor(endrow / 2) - 1}, {ceil(endcol / 2), endcol - 1}},
      {{ceil(endrow / 2), endrow - 1}, {0, floor(endcol / 2) - 1}},
      {{ceil(endrow / 2), endrow - 1}, {ceil(endcol / 2), endcol - 1}}
    ]
    |> Enum.map(fn {{minrow, maxrow}, {mincol, maxcol}} ->
      Enum.filter(coords, fn {row, col} ->
        row >= minrow and row <= maxrow and
          col >= mincol and col <= maxcol
      end)
    end)
    |> Enum.map(&length/1)
    |> Enum.product()
  end

  defp parse(input) do
    String.replace(input, ~r/[pv]=/, "")
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [pos, vel] ->
      [col, row] =
        String.split(pos, ",")
        |> Enum.map(&String.to_integer/1)

      [velcol, velrow] =
        String.split(vel, ",")
        |> Enum.map(&String.to_integer/1)

      {{row, col}, {velrow, velcol}}
    end)
  end
end
