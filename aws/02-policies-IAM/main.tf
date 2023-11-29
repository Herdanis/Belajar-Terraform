provider "aws" {
  region = "ap-southeast-1"
  access_key = var.access_key
  secret_key = var.secret_key
}


resource "aws_iam_user" "admin-user" {
  name = "lucy"
  tags = {
    description = "Team Lead"
  }
}

resource "aws_iam_policy" "admin-policy" {
  name = "AdminUsers"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}
# resource "aws_iam_policy" "admin-policy" {
#   name = "AdminUsers"
#   policy = file("admin-policy.json")
# }

resource "aws_iam_user_policy_attachment" "lucy-admin-access" {
  user = aws_iam_user.admin-user.name
  policy_arn = aws_iam_policy.admin-policy.arn
}
