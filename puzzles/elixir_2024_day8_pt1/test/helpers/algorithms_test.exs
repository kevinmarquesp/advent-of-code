defmodule PuzzleTest.Helpers.Algorithms do
  use ExUnit.Case
  doctest Puzzle.Helpers.Algorithms
  alias Puzzle.Helpers.Algorithms

  test "the antinode when it's before the main antenna" do
    assert Algorithms.antinode({5, 5}, {3, 4}) == {7, 6}
  end

  test "the antinode when it's after the main antenna" do
    assert Algorithms.antinode({3, 4}, {5, 5}) == {1, 3}
  end

  test "the value getter for grids function is working" do
    assert Algorithms.grid_at([[1, 2], [3, 4]], {0, 0}) === 1
    assert Algorithms.grid_at([[1, 2], [3, 4]], {0, 1}) === 2
    assert Algorithms.grid_at([[1, 2], [3, 4]], {1, 0}) === 3
    assert Algorithms.grid_at([[1, 2], [3, 4]], {1, 1}) === 4
  end
end
