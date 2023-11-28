resource "local_file" "pet" {
  filename = each.value
  content = var.content
  for_each = toset(var.filename) 
}