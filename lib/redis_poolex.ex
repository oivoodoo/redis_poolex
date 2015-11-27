defmodule RedisPoolex do
  @moduledoc """
  Application for running connection pool and redis connection inside.
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

  @doc """
  `method_missing` implementation here for easy delegation of all redis
  related methods to redis client.

  ## Examples

    iex> RedisPoolex.set("key", "value")
    "OK"

    iex> RedisPoolex.get("key")
    "value"

    iex> RedisPoolex.get("unknown")
    :undefined

    iex> RedisPoolex.hset("user", "1", "user-value")
    "OK"

    iex> RedisPoolex.hget("users", "1")
    "user-value"
  """
  def unquote(:"$handle_undefined_function")(program, args) do
    command = to_string(program)

    RedisPoolex.Supervisor.q(command, args)
  end
end
