defmodule Puzzle.Helpers.Algorithms do
  @moduledoc """
  Algorithms needed to solve the puzzle that was separated from the main Puzzle
  package because thet `Puzzle.solve/1` would become too big and confusing.
  """

  @doc "Apply the puzzle rules to get the next stones based on a single one."
  def next_stones(0), do: [1]

  def next_stones(num) do
    len =
      (1 + :math.log10(num))
      |> floor()

    if rem(len, 2) == 0 do
      Integer.to_string(num)
      |> String.split_at(floor(len / 2))
      |> Tuple.to_list()
      |> Enum.map(&String.to_integer/1)
    else
      [num * 2024]
    end
  end
end
