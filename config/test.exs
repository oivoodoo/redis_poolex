import Config

config :logger, level: :warning

config :redis_poolex,
  connection_string: "redis://127.0.0.1:6379",
  pool_size: 10,
  pool_max_overflow: 1,
  timeout: 5_000
