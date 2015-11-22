defmodule RedisPoolex.Config do
  def get(name, default \\ nil) do
    Application.get_env(:redis_poolex, name, default)
  end
end
