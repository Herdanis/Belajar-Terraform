variable "project" {
  
}

variable "region" {
  
}

variable "zone" {
  
}

variable "name" {
  default = "my-kubernetes"
}

variable "location" {
  default = "us-east1-c"
}

variable "deletion_protection" {
  default = false
  type = bool
}

variable "machine_type" {
  default = "n1-standard-1"
}