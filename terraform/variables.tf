
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
  default = "vpc-05e17c74c9d28c359"
}

variable "secret_word" {
  type    = string
  default = "test"
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}



variable "zone_id" {
  type    = string
  default = "Z03733131J509SKDTP7XZ"
}