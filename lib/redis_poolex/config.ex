defmodule RedisPoolex.Config do
  @moduledoc false

  @doc """
  Return a value from the `:redis_poolex` application environment.
  """
  @spec get(atom(), term()) :: term()
  def get(name, default \\ nil) do
    Application.get_env(:redis_poolex, name, default)
  end

  @doc """
  Arguments passed to `Redix.start_link/1` for each pool worker.

  Uses `:connection_string` when set, otherwise `:host`, `:port`, `:password`,
  and `:db`.
  """
  @spec connection_args() :: binary() | keyword()
  def connection_args do
    case get(:connection_string) do
      nil ->
        [
          host: get(:host, "127.0.0.1"),
          port: get(:port, 6379),
          password: normalize_password(get(:password, nil)),
          database: get(:db, 0)
        ]

      connection_string when is_binary(connection_string) ->
        connection_string
    end
  end

  defp normalize_password(""), do: nil
  defp normalize_password(password), do: password
end
