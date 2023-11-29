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

data "aws_iam_user" "get-coba" {
  user_name = "coba"
}

output "user" {
  value = data.aws_iam_user.get-coba.user_name
}