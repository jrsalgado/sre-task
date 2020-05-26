output "ubuntu_bionic" {
  value = "${data.aws_ami.ubuntu_bionic.image_id}"
}
