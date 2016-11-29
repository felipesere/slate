use Mix.Config

config :slate, Slate.Catalog,
  adapter: Ecto.Adapters.Postgres,
  database: "catalog",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"
