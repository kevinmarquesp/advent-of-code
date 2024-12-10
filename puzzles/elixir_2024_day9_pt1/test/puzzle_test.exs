defmodule PuzzleTest do
  use ExUnit.Case
  doctest Puzzle

  test "example input result" do
    {:ok, raw} = File.read("inputs/example.txt")

    assert String.trim(raw)
           |> Puzzle.solve() == 1928
  end
end
