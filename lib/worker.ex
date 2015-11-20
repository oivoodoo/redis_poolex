defmodule RedisPoolex.Worker do
  @moduledoc """

  Worker for getting connction to Redis and run queries via `Exredis`

  """
  require Logger

  import Exredis

  use GenServer

  @doc"""
  State is storing %{conn: conn} for reusing it because of wrapping it by redis pool
  """
  def start_link(state) do
    :gen_server.start_link(__MODULE__, %{conn: nil}, [])
  end

  def init(state) do
    {:ok, state}
  end

  defmodule Connector do
    require Exredis

    # TODO: we should handle errors on connections here
    # in case of having disconnets we should notify by logger
    # at least.
    def connect() do
      {:ok, client} = Exredis.start_link

      client
    end

    def ensure_connection(conn) do
      if Process.alive?(conn) do
        conn
      else
        connect()
      end
    end
  end

  def handle_call(%{command: command, params: params}, _from, %{conn: nil}) do
    conn = Connector.connect
    {:reply, q(conn, command, params), %{conn: conn}}
  end

  def handle_call(%{command: command, params: params}, _from, %{conn: conn}) do
    conn = Connector.ensure_connection(conn)
    {:reply, q(conn, command, params), %{conn: conn}}
  end

  def handle_call(%{command: command}, _from, %{conn: nil}) do
    conn = Connector.connect
    {:reply, q(conn, command), %{conn: conn}}
  end

  def handle_call(%{command: command}, _from, %{conn: conn}) do
    conn = Connector.ensure_connection(conn)
    {:reply, q(conn, command), %{conn: conn}}
  end

  def q(conn, command, params \\ []) do
    query(conn, [command] ++ params)
  end
end
