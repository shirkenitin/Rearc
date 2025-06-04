
variable "region" {
  type    = string
  default = "ap-south-1"
}
variable "environment" {
  type    = string
  default = "dev"
}
variable "project_name" {
  type    = string
  default = "rearc"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0b1f4e232e4f681f2"
}

variable "secret_word" {
  type    = string
  default = "test"
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}
