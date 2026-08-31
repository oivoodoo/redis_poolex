import Config

config :redis_poolex,
  host: "127.0.0.1",
  port: 6379,
  password: nil,
  db: 0,
  pool_size: 10,
  pool_max_overflow: 1,
  timeout: 5_000
