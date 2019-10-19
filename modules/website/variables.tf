variable "ag_size" {
  default = "1"
}
variable "cidr_blocks" { 
  type = "list"
}

variable "environment" {
  default = "develop"
}

variable "image_id" {}

variable "name" {
  default = "webapp"
}

variable "subnet_ids" {
  type = "list"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_id" { }