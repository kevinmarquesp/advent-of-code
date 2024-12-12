defmodule PuzzleTest do
  use ExUnit.Case

  doctest Puzzle

  test "solution with the example input" do
    {:ok, raw} = File.read("inputs/example.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == -1
  end

  test "solution with the actual input" do
    {:ok, raw} = File.read("inputs/actual.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == -1
  end
end
