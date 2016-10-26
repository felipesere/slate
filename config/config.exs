# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :ex_aws,
  access_key_id: "ABC_ACCESS_KEY",
  secret_access_key: "SECRET_KEY_PASSWORD"

config :ex_aws, :s3, host: "localhost:9000", scheme: "http://"

config :slate,
  image_host: "http://s3.amazonaws.com"
        

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
