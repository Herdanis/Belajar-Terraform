resource "local_file" "hello" {
  filename = var.filename
  content = var.content["statement2"]
}

resource "random_pet" "pet" {
  length = var.length[0]
  prefix = var.prefix[2]
  separator = var.separator
}