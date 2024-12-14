defmodule PuzzleTest do
  use ExUnit.Case

  doctest Puzzle

  test "solution with the A and B plants" do
    {:ok, raw} = File.read("inputs/alt-ab.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 368
  end

  test "solution with the E and X plants" do
    {:ok, raw} = File.read("inputs/alt-ex.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 236
  end

  test "solution with the A, B, C and D plants" do
    {:ok, raw} = File.read("inputs/alt-abc.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 80
  end

  test "solution with the O and X plants" do
    {:ok, raw} = File.read("inputs/alt-ox.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 436
  end

  test "solution with the example input" do
    {:ok, raw} = File.read("inputs/example.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 1206
  end

  test "solution with the actual input" do
    {:ok, raw} = File.read("inputs/actual.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 870_202
  end
end
