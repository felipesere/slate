use Mix.Config

config :slate, Slate.Catalog,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "catalog_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"

config :slate, Slate.Admin.Authentication,
  username: "felipe",
  password: "sere"
