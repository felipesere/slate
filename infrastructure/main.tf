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
}

resource "aws_route53_zone" "main_zone" {
  name = "felipesere.com"
}

resource "aws_route53_record" "www-cname" {
  zone_id = "${aws_route53_zone.main_zone.zone_id}"
  name = "www"
  type = "CNAME"
  ttl = "300"
  records = ["${heroku_app.web.heroku_hostname}"]
}

resource "heroku_domain" "foobar" {
  app      = "${heroku_app.web.name}"
  hostname = "${aws_route53_zone.main_zone.name}"
}
