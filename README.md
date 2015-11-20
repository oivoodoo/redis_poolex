# RedisPoolex

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add redis_poolex to your list of dependencies in `mix.exs`:

        def deps do
          [{:redis_poolex, "~> 0.0.1"}]
        end

  2. Ensure redis_poolex is started before your application:

        def application do
          [applications: [:redis_poolex]]
        end
