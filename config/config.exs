# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :slate,
  image_host: "http://s3.amazonaws.com",
  ecto_repos: [Slate.Catalog]

config :slate, Slate.Catalog,
  adapter: Ecto.Adapters.Postgres

# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).

import_config "#{Mix.env}.exs"
