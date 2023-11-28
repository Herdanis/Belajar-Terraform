resource "local_file" "hello" {
  filename = var.filename
  content = var.content
}

resource "random_pet" "pet" {
  length = var.length
  prefix = var.prefix
  separator = var.separator
}