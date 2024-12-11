defmodule PuzzleTest.Helpers.Algorithms do
  alias Puzzle.Helpers.Algorithms
  use ExUnit.Case
  doctest Puzzle.Helpers.Algorithms

  test "the algorithm to check the next number" do
    assert Algorithms.next_stones(0) == [1]
    assert Algorithms.next_stones(22) == [2, 2]
    assert Algorithms.next_stones(1000) == [10, 0]
    assert Algorithms.next_stones(3) == [3 * 2024]
  end
end
