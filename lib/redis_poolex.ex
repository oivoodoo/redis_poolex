defmodule RedisPoolex do
  @moduledoc ~S"""
  Application for running connection pool and redis connection inside.

  ## Example:

    ```elixir
    alias RedisPoolex, as: Redis

    Redis.query(["SET", "key1", "value1"]) => "OK"
    Redis.query(["GET", "key1"]) => "value1"
    Redis.query(["GET", "key2"]) => :undefined
    ```
  """

  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(RedisPoolex.Supervisor, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RedisPoolex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc ~S"""
  `query` sends commands directly to Redis
  """
  def query(args) do
    RedisPoolex.Supervisor.q(args)
  end

  @doc ~S"""
  `query_pipe` sends multiple commands as batch directly to Redis.
  """
  def query_pipe(args) do
    RedisPoolex.Supervisor.p(args)
  end
end
