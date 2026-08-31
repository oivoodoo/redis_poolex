defmodule RedisPoolex do
  @moduledoc """
  Redis connection pool using poolboy and Redix.

  ## Examples

      alias RedisPoolex, as: Redis

      Redis.query(["SET", "key1", "value1"])
      #=> "OK"

      Redis.query(["GET", "key1"])
      #=> "value1"

      Redis.query(["GET", "key2"])
      #=> nil
  """

  @spec query(Redix.command()) :: Redix.Protocol.redis_value()
  def query(args) do
    RedisPoolex.Supervisor.query(args)
  end

  @spec query_pipe([Redix.command()]) :: [Redix.Protocol.redis_value()]
  def query_pipe(args) do
    RedisPoolex.Supervisor.query_pipe(args)
  end
end
