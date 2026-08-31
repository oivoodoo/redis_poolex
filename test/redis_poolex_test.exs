defmodule RedisPoolexTest do
  use ExUnit.Case

  alias RedisPoolex, as: Redis

  setup do
    Redis.query(["FLUSHDB"])
    :ok
  end

  test "basic commands using the connection pool" do
    assert Redis.query(["SET", "key", "value"]) == "OK"
    assert Redis.query(["GET", "key"]) == "value"

    assert Redis.query(["HSET", "users", "1", "value"]) == 1
    assert Redis.query(["HGET", "users", "1"]) == "value"
    assert Redis.query(["HGET", "users", "2"]) == nil
  end

  test "pipelines multiple operations" do
    assert Redis.query_pipe([
             ["SET", "key1", "value1"],
             ["SET", "key2", "value2"]
           ]) == ["OK", "OK"]

    assert Redis.query(["GET", "key1"]) == "value1"
    assert Redis.query(["GET", "key2"]) == "value2"
  end

  test "executes commands concurrently through the pool" do
    results =
      1..20
      |> Task.async_stream(
        fn i ->
          key = "concurrent:#{i}"
          assert Redis.query(["SET", key, "#{i}"]) == "OK"
          Redis.query(["GET", key])
        end,
        max_concurrency: 10,
        timeout: 5_000
      )
      |> Enum.map(fn {:ok, value} -> value end)

    assert results == Enum.map(1..20, &Integer.to_string/1)
  end

  test "raises on a Redis command error" do
    assert Redis.query(["SET", "nonstr", "x"]) == "OK"

    assert_raise Redix.Error, fn ->
      Redis.query(["INCR", "nonstr"])
    end
  end
end
