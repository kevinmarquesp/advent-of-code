defmodule Puzzle do
  alias Puzzle.Core.Logic

  @doc "Starts by getting only the walls, boxes and robot's coordinates to solve."
  def solve(input) do
    {robot, bounds, boxes, walls, moves} = parse(input)

    {_, finalboxes} =
      for direction <- moves, reduce: {robot, boxes} do
        {robot, boxes} ->
          case Logic.move(robot, direction, bounds, boxes, walls) do
            {:ok, newrobot, newboxes} -> {newrobot, newboxes}
            _ -> {robot, boxes}
          end
      end

    Enum.map(finalboxes, &(100 * elem(&1, 0) + elem(&1, 1)))
    |> Enum.sum()
  end

  defp parse(input) do
    [rawmap, rawmoves] = String.split(input, "\n\n")

    map =
      String.split(rawmap, "\n")
      |> Enum.map(&String.codepoints/1)

    {maxrow, maxcol} = {length(map) - 1, length(Enum.at(map, 0)) - 1}

    {robot, boxes, walls} =
      for row <- 0..maxrow,
          col <- 0..maxcol,
          Logic.grid_at(map, row, col) != ".",
          reduce: {{nil, nil}, [], []} do
        {robot, boxes, walls} ->
          case Logic.grid_at(map, row, col) do
            "#" -> {robot, boxes, walls ++ [{row, col}]}
            "O" -> {robot, boxes ++ [{row, col}], walls}
            "@" -> {{row, col}, boxes, walls}
          end
      end

    {
      robot,
      {maxrow, maxcol},
      boxes,
      walls,
      String.split(rawmoves, "\n")
      |> Enum.flat_map(&String.codepoints/1)
      |> Enum.map(fn
        "^" -> :up
        ">" -> :right
        "v" -> :down
        "<" -> :left
      end)
    }
  end
end
