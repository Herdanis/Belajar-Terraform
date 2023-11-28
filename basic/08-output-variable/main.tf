resource "local_file" "pet" {
  filename = var.filename
  content = "My Favorite pet is ${random_pet.my-pet.id}"
  depends_on = [ random_pet.my-pet ]
}

resource "random_pet" "my-pet" {
  prefix = var.prefix
  separator = var.separator
  length = var.length
  
}

output "pet-name" {
  value = random_pet.my-pet
  description = "Recourd value of pet module"
}