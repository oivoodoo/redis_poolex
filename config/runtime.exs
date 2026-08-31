import Config

if url = System.get_env("REDIS_URL") do
  config :redis_poolex, connection_string: url
end
