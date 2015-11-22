defmodule RedisPoolex.Worker do
  @moduledoc """
  Worker for getting connction to Redis and run queries via `Exredis`
  """
  require Logger

  import Exredis

  use GenServer

  @doc"""
  State is storing %{conn: conn} for reusing it because of wrapping it by redis pool

  `state` - default state is `%{conn: nil}`
  """
  def start_link(_state) do
    :gen_server.start_link(__MODULE__, %{conn: nil}, [])
  end

  def init(state) do
    {:ok, state}
  end

  defmodule Connector do
    require Exredis
    require Logger

    alias RedisPoolex.Config

    @doc """
    Using config `redis_poolex` to connect to redis server via `Exredis`
    """
    def connect() do
      host = Config.get(:host, "127.0.0.1")
      port = Config.get(:port, 6379)
      password = Config.get(:password, "")
      database = Config.get(:db, 0)
      reconnect = Config.get(:reconnect, :no_reconnect)

      Logger.debug "[Connector] connecting to redis server..."

      {:ok, client} = Exredis.start_link(host, port, database, password, reconnect)

      client
    end

    @doc """
    Checking padjhfocess alive or not in case if we don't have connection we should
    connect to redis server.
    """
    def ensure_connection(conn) do
      if Process.alive?(conn) do
        conn
      else
        Logger.debug "[Connector] redis connection is died, it will renew connection."
        connect()
      end
    end
  end

  @doc false
  def handle_call(%{command: command, params: params}, _from, %{conn: nil}) do
    conn = Connector.connect
    {:reply, q(conn, command, params), %{conn: conn}}
  end

  @doc false
  def handle_call(%{command: command, params: params}, _from, %{conn: conn}) do
    conn = Connector.ensure_connection(conn)
    {:reply, q(conn, command, params), %{conn: conn}}
  end

  @doc false
  def handle_call(%{command: command}, _from, %{conn: nil}) do
    conn = Connector.connect
    {:reply, q(conn, command), %{conn: conn}}
  end

  @doc false
  def handle_call(%{command: command}, _from, %{conn: conn}) do
    conn = Connector.ensure_connection(conn)
    {:reply, q(conn, command), %{conn: conn}}
  end

  @doc false
  def q(conn, command, params \\ []) do
    query(conn, [command] ++ params)
  end
end
