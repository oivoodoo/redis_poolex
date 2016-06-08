use Mix.Config

config :redis_poolex,
host: "127.0.0.1",
port: 6379,
password: "",
db: 0,
reconnect: :no_reconnect,
max_queue: :infinity,
pool_size: 10,
pool_max_overflow: 1

# or

# config :redis_poolex,
# connection_string: "redis://127.0.0.1:6379",
# pool_size: 10,
# pool_max_overflow: 1
