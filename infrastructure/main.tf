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

resource "heroku_addon" "database" {
  app = "${heroku_app.web.name}"
  plan = "heroku-postgresql:hobby-dev"
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

resource "aws_iam_user" "slate" {
    name = "slate"
    path = "/system/"
}

resource "aws_iam_access_key" "slate" {
    user = "${aws_iam_user.slate.name}"
}

resource "aws_iam_user_policy" "slate_rw" {
    name = "slate_rw"
    user = "${aws_iam_user.slate.name}"
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
                "AWS": "${aws_iam_user.slate.arn}"
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

resource "aws_iam_role" "iam_for_lambda" {
    name = "iam_for_lambda"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "allow_lambda_access_to_s3" {
    name = "lambda_to_s3"
    role = "${aws_iam_role.iam_for_lambda.id}"
    policy = <<EOF
{
      "Version": "2012-10-17",
        "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "logs:*"
          ],
          "Resource": "arn:aws:logs:*:*:*"
        },
        {
          "Effect": "Allow",
          "Action": [
            "s3:GetObject",
          "s3:PutObject"
          ],
          "Resource": [
            "arn:aws:s3:::${var.bucket_name}",
            "arn:aws:s3:::${var.bucket_name}/*"
          ]
        }
        ]
}
EOF
}

resource "aws_lambda_permission" "allow_bucket" {
    statement_id = "AllowExecutionFromS3Bucket"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.func.arn}"
    principal = "s3.amazonaws.com"
    source_arn = "${aws_s3_bucket.prod_bucket.arn}"
}

resource "aws_lambda_function" "func" {
    filename = "../resizer/.serverless/resizer.zip"
    source_code_hash = "${base64sha256(file("../resizer/.serverless/resizer.zip"))}"
    function_name = "resizer-lambda-2"
    runtime = "nodejs4.3"
    timeout = 30
    memory_size = 512
    role = "${aws_iam_role.iam_for_lambda.arn}"
    handler = "handler.resize"
}
resource "aws_s3_bucket_notification" "bucket_notification" {
    bucket = "${aws_s3_bucket.prod_bucket.id}"
    lambda_function {
        lambda_function_arn = "${aws_lambda_function.func.arn}"
        events = ["s3:ObjectCreated:*"]
        filter_prefix = "images/"
        filter_suffix = ".jpg"
    }
}

output "secret" {
  value = "${aws_iam_access_key.slate.secret}"

}
