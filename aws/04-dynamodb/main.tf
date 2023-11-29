provider "aws" {
  region = "ap-southeast-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_dynamodb_table" "cars" {
  name = "cars"
  hash_key = "VIN"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "VIN"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "car-items" {
  table_name = aws_dynamodb_table.cars.name
  hash_key = aws_dynamodb_table.cars.hash_key
  item = <<EOF
{
  "Manufacturer": {"S": "Toyota"},
  "Make" : {"S": "Corolla"},
  "Year" : {"N": "2004"},
  "VIN" : {"S": "4Y1SL65848Z411439"}
}
EOF
}