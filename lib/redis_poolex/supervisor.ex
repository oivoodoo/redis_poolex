defmodule RedisPoolex.Supervisor do
  @moduledoc """
  Supervisor for a poolboy pool of Redix connections.
  """

  use Supervisor

  alias RedisPoolex.Config

  @pool_name :redis_pool

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    pool_options = [
      name: {:local, @pool_name},
      worker_module: Redix,
      size: Config.get(:pool_size, 10),
      max_overflow: Config.get(:pool_max_overflow, 1)
    ]

    children = [
      :poolboy.child_spec(@pool_name, pool_options, Config.connection_args())
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @spec query(Redix.command()) :: Redix.Protocol.redis_value()
  def query(args) do
    timeout = Config.get(:timeout, 5_000)

    :poolboy.transaction(
      @pool_name,
      fn conn -> Redix.command!(conn, args, timeout: timeout) end,
      timeout
    )
  end

  @spec query_pipe([Redix.command()]) :: [Redix.Protocol.redis_value()]
  def query_pipe(args) do
    timeout = Config.get(:timeout, 5_000)

    :poolboy.transaction(
      @pool_name,
      fn conn -> Redix.pipeline!(conn, args, timeout: timeout) end,
      timeout
    )
  end
end
