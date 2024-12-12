defmodule Puzzle.Core.LogicTest do
  use ExUnit.Case

  doctest Puzzle.Core.Logic

  alias Puzzle.Core.Logic

  describe "perimeter/1" do
    test "returns the perimeter of a given region" do
      region = [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
      result = Logic.perimeter(region)
      expected = [{0, -1}, {0, 2}, {-1, 0}, {-1, 1}, {1, -1}, {1, 2}, {2, 0}, {2, 1}]

      assert Enum.sort(result) == Enum.sort(expected)

      region = [{2, 2}, {2, 3}, {3, 2}, {3, 3}]
      result = Logic.perimeter(region)
      expected = [{1, 2}, {1, 3}, {2, 1}, {2, 4}, {3, 1}, {3, 4}, {4, 2}, {4, 3}]

      assert Enum.sort(result) == Enum.sort(expected)
    end
  end

  describe "region/5" do
    test "returns all positions in the same region" do
      grid = [[1, 1, 2, 2], [1, 1, 2, 2], [3, 3, 4, 4], [3, 3, 4, 4]]
      bounds = {3, 3}
      result = Logic.region(grid, 1, {0, 0}, bounds)
      expected = [{0, 0}, {0, 1}, {1, 0}, {1, 1}]

      assert Enum.sort(result) == Enum.sort(expected)

      result = Logic.region(grid, 2, {0, 2}, bounds)
      expected = [{0, 2}, {0, 3}, {1, 2}, {1, 3}]

      assert Enum.sort(result) == Enum.sort(expected)

      result = Logic.region(grid, 3, {2, 0}, bounds)
      expected = [{2, 0}, {2, 1}, {3, 0}, {3, 1}]

      assert Enum.sort(result) == Enum.sort(expected)

      result = Logic.region(grid, 4, {2, 2}, bounds)
      expected = [{2, 2}, {2, 3}, {3, 2}, {3, 3}]

      assert Enum.sort(result) == Enum.sort(expected)
    end
  end

  test "if the Logic.grid_at/3 is propperly getting fetching a grid value" do
    assert Logic.grid_at([[1, 2], [3, 4]], 0, 0) === 1
    assert Logic.grid_at([[1, 2], [3, 4]], 0, 1) === 2
    assert Logic.grid_at([[1, 2], [3, 4]], 1, 0) === 3
    assert Logic.grid_at([[1, 2], [3, 4]], 1, 1) === 4
  end

  describe "grid_within_bounds?/2" do
    test "returns true when the coordinate is within bounds" do
      assert Logic.grid_within_bounds?({2, 3}, {4, 4})
      assert Logic.grid_within_bounds?({0, 0}, {4, 4})
      assert Logic.grid_within_bounds?({4, 4}, {4, 4})
    end

    test "returns false when the coordinate is out of bounds" do
      refute Logic.grid_within_bounds?({-1, 3}, {4, 4})
      refute Logic.grid_within_bounds?({2, 5}, {4, 4})
      refute Logic.grid_within_bounds?({5, 0}, {4, 4})
    end
  end

  describe "grid_neighbors/3" do
    test "returns only orthogonal neighbors when diagonal: false" do
      neighbors = Logic.grid_neighbors({2, 2}, {4, 4}, diagonal: false)

      assert neighbors == [{1, 2}, {2, 1}, {2, 3}, {3, 2}]
    end

    test "filters out neighbors out of bounds when diagonal: false" do
      neighbors = Logic.grid_neighbors({0, 0}, {4, 4}, diagonal: false)

      assert neighbors == [{0, 1}, {1, 0}]
    end

    test "returns orthogonal and diagonal neighbors when diagonal: true" do
      neighbors = Logic.grid_neighbors({2, 2}, {4, 4}, diagonal: true)

      assert neighbors == [{1, 1}, {1, 2}, {1, 3}, {2, 1}, {2, 3}, {3, 1}, {3, 2}, {3, 3}]
    end

    test "filters out neighbors out of bounds when diagonal: true" do
      neighbors = Logic.grid_neighbors({0, 0}, {4, 4}, diagonal: true)

      assert neighbors == [{0, 1}, {1, 0}, {1, 1}]
    end
  end
end
