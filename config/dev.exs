use Mix.Config

config :slate, Slate.Catalog,
  adapter: Ecto.Adapters.Postgres,
  database: "catalog",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"

config :slate, Slate.Admin.Authentication,
  username: "felipe",
  password: "sere"
