resource "aws_s3_bucket" "web_bucket" {
    bucket = "staging.weareweekday.com"
    acl = "public-read"
    policy = "${file("web_bucket_policy.json")}"

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