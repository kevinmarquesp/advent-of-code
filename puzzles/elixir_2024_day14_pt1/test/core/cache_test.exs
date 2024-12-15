defmodule Puzzle.Core.CacheTest do
  use ExUnit.Case

  doctest Puzzle.Core.Cache

  alias Puzzle.Core.Cache

  setup do
    {:ok, pid} = Cache.start_link()

    assert is_pid(pid)

    :ok
  end

  test "put/2 adds a value to the cache" do
    Cache.put(:key1, "value1")

    assert Cache.get(:key1) == "value1"
  end

  test "get/1 retrieves the correct value" do
    Cache.put(:key2, "value2")

    assert Cache.get(:key2) == "value2"
  end

  test "get/1 returns :noindex for missing key" do
    assert Cache.get(:missing_key) == :noindex
  end

  test "put_uniq/2 adds a value if the key does not exist" do
    Cache.put_uniq(:unique_key, "unique_value")

    assert Cache.get(:unique_key) == "unique_value"
  end

  test "put_uniq/2 does not overwrite an existing key" do
    Cache.put(:existing_key, "original_value")
    Cache.put_uniq(:existing_key, "new_value")

    assert Cache.get(:existing_key) == "original_value"
  end
end
