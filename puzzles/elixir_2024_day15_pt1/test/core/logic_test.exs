defmodule Puzzle.Core.LogicTest do
  use ExUnit.Case

  doctest Puzzle.Core.Logic

  alias Puzzle.Core.Logic

  describe "move/5" do
    test "robot moves to an empty space" do
      bounds = {7, 7}
      walls = []
      boxes = []

      assert Logic.move({3, 3}, :right, bounds, boxes, walls) == {:ok, {3, 4}, boxes}
    end

    test "robot hits a wall" do
      bounds = {7, 7}
      walls = [{3, 4}]
      boxes = []

      assert Logic.move({3, 3}, :right, bounds, boxes, walls) ==
               {:wall, {3, 4}, boxes}
    end

    test "robot pushes a box successfully" do
      bounds = {7, 7}
      walls = []
      boxes = [{3, 4}]

      assert Logic.move({3, 3}, :right, bounds, boxes, walls) ==
               {:ok, {3, 4}, [{3, 5}]}
    end

    test "robot fails to push a box into a wall" do
      bounds = {7, 7}
      walls = [{3, 5}]
      boxes = [{3, 4}]

      assert Logic.move({3, 3}, :right, bounds, boxes, walls) ==
               {:stop, {3, 4}, boxes}
    end

    test "robot attempts to move out of bounds" do
      bounds = {7, 7}
      walls = []
      boxes = []

      assert Logic.move({0, 0}, :up, bounds, boxes, walls) == {:out, {-1, 0}}
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
