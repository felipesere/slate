provider "aws" {
  region = "${var.region}"
}

provider "heroku" {
  email = "feilpesere@gmail.com"
  api_key = "${var.heroku_api_key}"
}

resource "heroku_app" "web" {
  name = "slate-blog"
  region = "us"
  config_vars {
    BUILDPACK_URL = "https://github.com/HashNuke/heroku-buildpack-elixir.git"
  }
}
