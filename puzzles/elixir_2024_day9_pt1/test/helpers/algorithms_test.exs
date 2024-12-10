defmodule PuzzleTest.Helpers.Algorithms do
  use ExUnit.Case
  doctest Puzzle.Helpers.Algorithms
  alias Puzzle.Helpers.Algorithms

  test "the mapper function output" do
    expected =
      "00...111...2...333.44.5555.6666.777.888899"
      |> String.codepoints()
      |> Enum.map(fn
        "." -> nil
        char -> String.to_integer(char)
      end)

    disk_map =
      "2333133121414131402"
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)

    assert Algorithms.map_blocks(disk_map) == expected
  end

  test "the checksum calculation" do
    blocks =
      "0099811188827773336446555566.............."
      |> String.codepoints()
      |> Enum.map(fn
        "." -> nil
        char -> String.to_integer(char)
      end)

    assert Algorithms.calc_checksum(blocks) == 1928
  end
end
