variable "filename" {
}

variable "content" {
  default = {
    "statement1" = "Hello World 01"
    "statement2" = "Hello World02"
  }
  type = map(string)
}

variable "prefix" {
  type = list(string)
}

variable "separator" {
  default = "."
}

variable "length" {
  type = list(number)
}

variable "bella" {
  type = object({
    name = string
    color = string
    age = number
    food = list(string)
    favorited_pat = bool
  })
  default = {
    name = "bella"
    color = "blue"
    age = 3
    food = [ "fish", "meat", "chicken" ]
    favorited_pat = false
  }
}

variable "kitty" {
  type = tuple([ string, number, bool ])
  default = [ "kitty", 1, false ]
}