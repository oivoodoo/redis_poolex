defmodule RedisPoolex.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [RedisPoolex.Supervisor]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
