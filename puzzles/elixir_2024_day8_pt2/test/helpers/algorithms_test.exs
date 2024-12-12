defmodule PuzzleTest.Helpers.Algorithms do
  use ExUnit.Case
  doctest Puzzle.Helpers.Algorithms
  alias Puzzle.Helpers.Algorithms

  test "the antinodes given two coordinates and a grid bounderies" do
    assert Algorithms.antinodes({2, 1}, {0, 0}, {9, 9}) ==
             [{2, 1}, {0, 0}, {4, 2}, {6, 3}, {8, 4}]

    assert Algorithms.antinodes({1, 3}, {0, 0}, {9, 9}) ==
             [{1, 3}, {0, 0}, {2, 6}, {3, 9}]

    assert Algorithms.antinodes({1, 3}, {2, 1}, {9, 9}) ==
             [{1, 3}, {2, 1}, {0, 5}]
  end

  test "the value getter for grids function is working" do
    assert Algorithms.grid_at([[1, 2], [3, 4]], {0, 0}) === 1
    assert Algorithms.grid_at([[1, 2], [3, 4]], {0, 1}) === 2
    assert Algorithms.grid_at([[1, 2], [3, 4]], {1, 0}) === 3
    assert Algorithms.grid_at([[1, 2], [3, 4]], {1, 1}) === 4
  end
end
