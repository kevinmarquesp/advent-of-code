defmodule PuzzleTest do
  use ExUnit.Case
  doctest Puzzle

  test "example input result" do
    {:ok, raw} = File.read("inputs/example.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 55312
  end

  test "with the actual puzzle input file" do
    {:ok, raw} = File.read("inputs/actual.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 186_424
  end
end
