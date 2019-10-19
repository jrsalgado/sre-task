
data "aws_ami" "ubuntu_bionic" {
  most_recent      = true
  # Canonical oficial image
  # name_regex = "ubuntu/images/hvm-instance/ubuntu-bionic-18.04-amd64-server-*"
  owners           = ["099720109477"]

  # filter {
  #   name   = "name"
  #   values = ["ubuntu/images/hvm-instance/ubuntu-bionic-18.04-amd64-server-20191010"]
  # }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}