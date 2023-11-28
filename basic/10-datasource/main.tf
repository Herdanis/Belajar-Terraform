resource "local_file" "pet" {
  filename = "pets.txt"
  content = data.local_file.dog.content
}

data "local_file" "dog" {
  filename = "my-dog.txt"
}