defmodule PuzzleTest.Helpers.Algorithms do
  alias Puzzle.Helpers.Algorithms
  use ExUnit.Case
  doctest Puzzle.Helpers.Algorithms

  test "the value getter for grids function is working" do
    assert Algorithms.grid_at([[1, 2], [3, 4]], {0, 0}) === 1
    assert Algorithms.grid_at([[1, 2], [3, 4]], {0, 1}) === 2
    assert Algorithms.grid_at([[1, 2], [3, 4]], {1, 0}) === 3
    assert Algorithms.grid_at([[1, 2], [3, 4]], {1, 1}) === 4
  end

  test "if the surrounding function returns no positions for an empty matrix" do
    assert Algorithms.next_adjacent([], {0, 0}, {0, 0}) == []
  end

  test "if the surrounding function handles the top-left corner" do
    assert Algorithms.next_adjacent(
             [[8, 1, 6], [1, 0, 1], [4, 3, 2]],
             {0, 0},
             {2, 2}
           ) == []
  end

  test "if the surrounding function handles the bottom-right corner" do
    assert Algorithms.next_adjacent(
             [[8, 1, 6], [1, 0, 1], [4, 3, 2]],
             {2, 2},
             {2, 2}
           ) == [{2, 1}]
  end

  test "if the surrounding function handles an edge position (top edge)" do
    assert Algorithms.next_adjacent(
             [[8, 1, 6], [1, 0, 1], [4, 3, 2]],
             {0, 1},
             {2, 2}
           ) == []
  end

  test "if the surrounding function handles an edge position (bottom edge)" do
    assert Algorithms.next_adjacent(
             [[8, 1, 6], [1, 0, 1], [4, 3, 2]],
             {2, 1},
             {2, 2}
           ) == [{2, 0}]
  end

  test "if the surrounding function handles an edge position (left edge)" do
    assert Algorithms.next_adjacent(
             [[8, 1, 6], [1, 0, 1], [4, 3, 2]],
             {1, 0},
             {2, 2}
           ) == []
  end

  test "if the surrounding function handles an edge position (right edge)" do
    assert Algorithms.next_adjacent(
             [[8, 1, 6], [1, 0, 1], [4, 3, 2]],
             {1, 2},
             {2, 2}
           ) == [{2, 2}]
  end

  test "if the surrounding function handles the center of a larger matrix" do
    assert Algorithms.next_adjacent(
             [[8, 1, 6, 5], [1, 0, 1, 2], [4, 3, 2, 9], [7, 8, 4, 3]],
             {1, 2},
             {3, 3}
           ) == [{1, 3}, {2, 2}]
  end
end
