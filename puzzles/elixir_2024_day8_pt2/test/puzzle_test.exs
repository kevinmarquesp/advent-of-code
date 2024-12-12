defmodule PuzzleTest do
  use ExUnit.Case
  doctest Puzzle

  test "example input result" do
    {:ok, raw} = File.read("inputs/example.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 34
  end

  test "right puzzle answer" do
    {:ok, raw} = File.read("inputs/actual.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 1200
  end
end
