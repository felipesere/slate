use Mix.Config

config :slate, Slate.Catalog,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

config :slate, Slate.Admin.Authentication,
  username: System.get_env("USERNAME"),
  password: System.get_env("PASSWORD")

config :logger,
  backends: [:console]
