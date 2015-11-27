defmodule RedisPoolex.Config do
  @doc """
  Return value by key from config.exs file.
  """
  def get(name, default \\ nil) do
    Application.get_env(:redis_poolex, name, default)
  end
end
