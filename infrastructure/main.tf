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

resource "heroku_domain" "public-domain" {
  app      = "${heroku_app.web.name}"
  hostname = "${aws_route53_record.www-cname.fqdn}"
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

resource "aws_iam_user" "maoni" {
    name = "maoni"
    path = "/system/"
}

resource "aws_iam_access_key" "maoni" {
    user = "${aws_iam_user.maoni.name}"
}

resource "aws_iam_user_policy" "maoni_rw" {
    name = "maoni_rw"
    user = "${aws_iam_user.maoni.name}"
    policy= <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        }
   ]
}
EOF
}

resource "aws_s3_bucket" "prod_bucket" {
    bucket = "${var.bucket_name}"
    acl = "public-read"

    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["PUT","POST"]
        allowed_origins = ["*"]
        expose_headers = ["ETag"]
        max_age_seconds = 3000
    }

    policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "PublicReadForGetBucketObjects",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.bucket_name}/*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_iam_user.maoni.arn}"
            },
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        }
    ]
}
EOF
}

output "secret" {
  value = "${aws_iam_access_key.maoni.secret}"
}
