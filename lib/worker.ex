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
      connection_string = Config.get(:connection_string)
      client = if connection_string do
        Exredis.start_using_connection_string(connection_string)
      else
        host = Config.get(:host, "127.0.0.1")
        port = Config.get(:port, 6379)
        password = Config.get(:password, "")
        database = Config.get(:db, 0)
        reconnect = Config.get(:reconnect, :no_reconnect)

        {:ok, client} = Exredis.start_link(host, port, database, password, reconnect)
        client
      end

      Logger.debug "[Connector] connecting to redis server..."

      client
    end

    @doc """
    Checking process alive or not in case if we don't have connection we should
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
    case command do
      :query -> {:reply, q(conn, params), %{conn: conn}}
      :query_pipe -> {:reply, p(conn, params), %{conn: conn}}
    end
  end

  @doc false
  def handle_call(%{command: command, params: params}, _from, %{conn: conn}) do
    conn = Connector.ensure_connection(conn)
    case command do
      :query -> {:reply, q(conn, params), %{conn: conn}}
      :query_pipe -> {:reply, p(conn, params), %{conn: conn}}
    end
  end

  @doc false
  def q(conn, params) do
    query(conn, params)
  end

  @doc false
  def p(conn, params) do
    query_pipe(conn, params)
  end
end
