
output "vpc_id_default" {
  value = "${data.aws_vpc.default.id}"
}

output "subnet_ids_default" {
  value = "${data.aws_subnet_ids.default.ids}"
}