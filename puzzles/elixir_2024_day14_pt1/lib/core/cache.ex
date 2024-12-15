defmodule Puzzle.Core.Cache do
  @moduledoc """
  Simple hashmap cache implemented with `GenServer`'s. It would be useful for
  applying *memoization* strategies!
  """

  use GenServer

  @name Cache

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  # SECTION: Client methods API.

  @doc "Adds a new `value` to the cached hashmap with the `key` index."
  def put(key, value), do: GenServer.cast(@name, {:put, key, value})

  @doc "Only put the `value` in `key` if *`key` doesn't already exists*."
  def put_uniq(key, value), do: GenServer.cast(@name, {:put_uniq, key, value})

  @doc "Get the cached value stored in the `key` index."
  def get(key), do: GenServer.call(@name, {:get, key})

  # SECTION: Server methods API.

  def handle_cast({:put, key, value}, cache) do
    {:noreply, Map.put(cache, key, value)}
  end

  def handle_cast({:put_uniq, key, value}, cache) do
    if not Map.has_key?(cache, key) do
      {:noreply, Map.put(cache, key, value)}
    else
      {:noreply, cache}
    end
  end

  def handle_call({:get, key}, _from, cache) do
    if not Map.has_key?(cache, key) do
      {:reply, :noindex, cache}
    else
      {:reply, cache[key], cache}
    end
  end
end
