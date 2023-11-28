resource "local_file" "hello" {
  filename = "hello.txt"
  content = "Hello World"
}

resource "random_pet" "pet" {
  length = 1
  prefix = "Mr"
  separator = "."
}