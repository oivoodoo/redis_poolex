defmodule RedisPoolexTest do
  use ExUnit.Case
  doctest RedisPoolex

  alias RedisPoolex, as: Redis

  test "basic method using connection pool" do
    Redis.query(["FLUSHDB"])

    Redis.query(["SET", "key", "value"])
    assert Redis.query(["GET", "key"]) == "value"

    Redis.query(["HSET", "users", "1", "value"])
    assert Redis.query(["HGET", "users", "1"]) == "value"
    assert Redis.query(["HGET", "users", "2"]) == :undefined
  end

  test "use pipe for multiple operations" do
    Redis.query(["FLUSHDB"])

    Redis.query_pipe([
      ["SET", "key1", "value1"],
      ["SET", "key2", "value2"],
    ])
    assert Redis.query(["GET", "key1"]) == "value1"
    assert Redis.query(["GET", "key2"]) == "value2"
  end
end
