defmodule RedisPoolex.Supervisor do
  require Logger

  @moduledoc """

  Redis connection pool supervisor to handle connections via pool and reduce the number of opened connections via GenServer

  """
  use Supervisor

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  # TODO: add it as config options instead of compiled variables
  @pool_name :redis_pool
  @connections 10
  @max_overflow 1

  def init([]) do
    Logger.info "Testing supervisor init method on calling"

    # Here are my pool options
    pool_options = [
      name: {:local, @pool_name},
      worker_module: RedisPoolex.Worker,
      size: @connections,
      max_overflow: @max_overflow
    ]

    children = [
      :poolboy.child_spec(@pool_name, pool_options, [])
    ]

    supervise(children, strategy: :one_for_one)
  end

  def q(command, params) do
    :poolboy.transaction(:redis_pool, fn(worker) -> GenServer.call(worker, %{command: command, params: params}) end)
  end
end
