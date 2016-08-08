# RedisPoolex

Redis connection pool using poolboy and exredis libraries.

# Examples

    alias RedisPoolex, as: Redis

    Redis.query(["SET", "key1", "value1"]) => "OK"
    Redis.query(["GET", "key1"]) => "value1"
    Redis.query(["GET", "key2"]) => :undefined

## Installation

If [available in Hex](https://hex.pm/packages/redis_poolex), the package can be installed as:

  1. Add redis_poolex to your list of dependencies in `mix.exs`:

        def deps do
          [{:redis_poolex, "~> 0.0.5"}]
        end

  2. Ensure redis_poolex is started before your application:

        def application do
          [applications: [:redis_poolex]]
        end
