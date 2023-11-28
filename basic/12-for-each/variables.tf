variable "filename" {
  # type = set(string)
  type = list(string)
  default = [
  "pets.txt",
  "dogs.txt",
  "cats.txt",
  ]
}

variable "content" {
  default = "this is my pets"
}