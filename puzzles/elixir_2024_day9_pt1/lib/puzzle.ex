defmodule Puzzle do
  @moduledoc """
  TODO: Describe your logic to solve this puzzle, you know, it's fun to share!
  """

  alias Puzzle.Helpers.Algorithms

  @doc """
  Parses the input file's content to a struct that Elixir can work with before
  doing the steps to solve it.
  """
  def solve(raw) when is_bitstring(raw) do
    String.codepoints(raw)
    |> Enum.map(&String.to_integer/1)
    |> solve()
  end

  def solve(disk_map) do
    blocks = Algorithms.map_blocks(disk_map)
    size = Enum.count(blocks, &is_number/1) - 1

    # Find the last number and swap it with the current index if it's `nil`.
    Enum.reduce(0..size, blocks, fn idx, acc ->
      case Enum.at(acc, idx) do
        nil ->
          swap_idx =
            (Enum.reverse(acc)
             |> Enum.find_index(&is_number/1)) * -1 - 1

          List.replace_at(acc, idx, Enum.at(acc, swap_idx))
          |> List.replace_at(swap_idx, nil)

        _ ->
          acc
      end
    end)
    |> Algorithms.calc_checksum()
  end
end
