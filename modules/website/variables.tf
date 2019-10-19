variable "ag_size" {
  default = "1"
}

variable "environment" {
  default = "develop"
}

variable "image_id" {}

variable "name" {
  default = "webapp"
}

variable "subnet_ids" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_id" { }