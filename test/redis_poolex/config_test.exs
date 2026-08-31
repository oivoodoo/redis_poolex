defmodule RedisPoolex.ConfigTest do
  use ExUnit.Case, async: false

  alias RedisPoolex.Config

  setup do
    original = Application.get_all_env(:redis_poolex)

    on_exit(fn ->
      for {key, _} <- Application.get_all_env(:redis_poolex) do
        Application.delete_env(:redis_poolex, key)
      end

      for {key, value} <- original do
        Application.put_env(:redis_poolex, key, value)
      end
    end)

    :ok
  end

  test "connection_args uses connection_string when set" do
    Application.put_env(:redis_poolex, :connection_string, "redis://example:6380")
    assert Config.connection_args() == "redis://example:6380"
  end

  test "connection_args falls back to host options and treats empty password as nil" do
    Application.delete_env(:redis_poolex, :connection_string)
    Application.put_env(:redis_poolex, :host, "10.0.0.1")
    Application.put_env(:redis_poolex, :port, 6380)
    Application.put_env(:redis_poolex, :password, "")
    Application.put_env(:redis_poolex, :db, 2)

    assert Config.connection_args() == [
             host: "10.0.0.1",
             port: 6380,
             password: nil,
             database: 2
           ]
  end
end
