defmodule Puzzle.Core.Debug do
  @moduledoc """
  Simple functions to help the developer debug a solution. For an example, by
  printing some *2D matrixes* into a *grid of strings* on the screen.
  """

  def display_map_state({initrow, initcol}, {maxrow, maxcol}, boxes, walls) do
    IO.puts("")

    for row <- 0..maxrow do
      for col <- 0..maxcol do
        cond do
          {row, col} == {initrow, initcol} -> "@"
          {row, col} in boxes -> "O"
          {row, col} in walls -> "#"
          true -> "."
        end
      end
      |> Enum.join("")
    end
    |> Enum.join("\n")
    |> IO.puts()
  end
end
