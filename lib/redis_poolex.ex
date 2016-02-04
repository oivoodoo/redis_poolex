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

  def query(args) do
    RedisPoolex.Supervisor.q(args)
  end

  def query_pipe(args) do
    RedisPoolex.Supervisor.p(args)
  end
end
