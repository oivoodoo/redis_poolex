# RedisPoolex

Redis connection pool for Elixir using [poolboy](https://hex.pm/packages/poolboy) and [Redix](https://hex.pm/packages/redix).

## Installation

Add `redis_poolex` to your dependencies in `mix.exs`:

```elixir
def deps do
  [{:redis_poolex, "~> 0.1.0"}]
end
```

## Configuration

In your application config:

```elixir
import Config

config :redis_poolex,
  connection_string: "redis://127.0.0.1:6379",
  pool_size: 10,
  pool_max_overflow: 1,
  timeout: 5_000
```

Or with discrete connection options:

```elixir
import Config

config :redis_poolex,
  host: "127.0.0.1",
  port: 6379,
  password: nil,
  db: 0,
  pool_size: 10,
  pool_max_overflow: 1,
  timeout: 5_000
```

| Option | Default | Description |
| --- | --- | --- |
| `:connection_string` | `nil` | Redis URI. When set, it takes precedence over host/port options. |
| `:host` | `"127.0.0.1"` | Redis host (used when `:connection_string` is unset). |
| `:port` | `6379` | Redis port. |
| `:password` | `nil` | Redis password. Empty strings are treated as no password. |
| `:db` | `0` | Redis database index. |
| `:pool_size` | `10` | Number of Redix workers in the pool. |
| `:pool_max_overflow` | `1` | Extra workers poolboy may start under load. |
| `:timeout` | `5_000` | Pool checkout and command timeout in milliseconds. |

## Usage

```elixir
alias RedisPoolex, as: Redis

Redis.query(["SET", "key1", "value1"])
#=> "OK"

Redis.query(["GET", "key1"])
#=> "value1"

Redis.query(["GET", "key2"])
#=> nil

Redis.query_pipe([
  ["SET", "key1", "value1"],
  ["SET", "key2", "value2"]
])
#=> ["OK", "OK"]
```

`query/1` and `query_pipe/1` return unwrapped Redis values. Redis errors and connection failures raise.

## Development

Redis must be available on `127.0.0.1:6379`, or set `REDIS_URL`.

```bash
mix deps.get
mix test
mix format
```

With Docker:

```bash
make build
make test
```

## Breaking changes in 0.1.0

This release replaces the unmaintained `exredis` client with Redix and requires Elixir 1.15+. Call sites that compared missing keys to `:undefined` should compare to `nil` instead. See `CHANGELOG.md`.
