defmodule RedisPoolexTest do
  use ExUnit.Case
  doctest RedisPoolex

  alias RedisPoolex, as: Redis

  test "basic method using connection pool" do
    Redis.flushdb

    Redis.set("key", "value")
    assert Redis.get("key") == "value"

    Redis.hset("users", "1", "value")
    assert Redis.hget("users", "1") == "value"
    assert Redis.hget("users", "2") == :undefined
  end
end
