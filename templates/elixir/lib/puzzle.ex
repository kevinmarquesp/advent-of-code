defmodule Puzzle do
  @moduledoc """
  TODO: Describe your logic to solve this puzzle, you know, it's fun to share!
  """

  @doc """
  Parses the input file's content to a struct that Elixir can work with before
  doing the steps to solve it.
  """
  def solve(raw) when is_bitstring(raw) do
    # TODO: Parse the content string...

    solve([])
  end

  def solve(_) do
    -1
  end
end
