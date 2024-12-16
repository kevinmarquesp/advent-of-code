defmodule PuzzleTest do
  use ExUnit.Case

  doctest Puzzle

  test "solution with the smaller example input" do
    {:ok, raw} = File.read("inputs/alt-small.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 2028
  end

  test "solution with the example input" do
    {:ok, raw} = File.read("inputs/example.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 10092
  end

  test "solution with the actual input" do
    {:ok, raw} = File.read("inputs/actual.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 1_398_947
  end
end
