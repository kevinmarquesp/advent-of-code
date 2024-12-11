defmodule Mix.Tasks.Solve do
  @moduledoc "Reads the actual input file (default) and start solving it."

  def run([]), do: run(["inputs/actual.txt"])

  def run([path | _]) do
    {:ok, raw} = File.read(path)

    String.trim(raw)
    |> Puzzle.solve()
    |> IO.puts()
  end
end
