defmodule Puzzle do
  @moduledoc """
  TODO: Describe your logic to solve this puzzle, you know, it's fun to share!
  """

  alias Puzzle.Helpers.Algorithms

  @doc "Parses the raw file content string to a list/tuple before solving it."
  def solve(raw) when is_bitstring(raw) do
    # TODO: Parse the content string...

    solve([])
  end

  def solve(_) do
    -1
  end
end
