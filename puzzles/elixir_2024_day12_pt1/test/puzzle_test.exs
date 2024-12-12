defmodule PuzzleTest do
  use ExUnit.Case

  doctest Puzzle

  test "solution with the A, B, C and D plants" do
    {:ok, raw} = File.read("inputs/alt-abc.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 140
  end

  test "solution with the O and X plants" do
    {:ok, raw} = File.read("inputs/alt-ox.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 772
  end

  test "solution with the example input" do
    {:ok, raw} = File.read("inputs/example.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 1930
  end

  test "solution with the actual input" do
    {:ok, raw} = File.read("inputs/actual.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 1_424_472
  end
end
