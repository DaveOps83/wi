data "template_file" "web_bucket_policy" {
  template = "${file("${path.module}/web_bucket_policy.json")}"
  vars {
    s3_env = "${var.s3_env}"
    s3_website_domain = "${var.s3_website_domain}"
  }
}

resource "aws_s3_bucket" "web_bucket" {
    bucket = "${var.s3_env}.${var.s3_website_domain}"
    acl = "public-read"
    policy = "${data.template_file.web_bucket_policy.rendered}"

    website {
        index_document = "index.html"
        routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
    }
}
