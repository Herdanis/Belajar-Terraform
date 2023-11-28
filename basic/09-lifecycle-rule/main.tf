resource "local_file" "pet" {
  filename = var.filename
  content = "Not my Favorite pet is ${random_pet.my-pet.id}"
  depends_on = [ random_pet.my-pet ]
  lifecycle {
    create_before_destroy = true
    ignore_changes = [ 
      content
    ]
  }
}

resource "random_pet" "my-pet" {
  prefix = var.prefix
  separator = var.separator
  length = var.length
  
}
