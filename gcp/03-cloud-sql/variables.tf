variable "project" {
  
}

variable "region" {
  
}

variable "zone" {
  
}

variable "name" {
  default = "mysql"
}

variable "network_region" {
  
}

variable "tier" {
  default = "db-f1-micro"
}

variable "backup-start" {
  default = "20:00"
}

variable "retention" {
  default = 7
  type = number
}

variable "ip-public" {
  default = "0.0.0.0/0"
}

variable "password" {
  
}

variable "db-name" {
  default = "coba"
}

variable "db-user" {
  default = "terraform"
}