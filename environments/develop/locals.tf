locals {
  environment = "develop"
  name        = "nginx-ha"
  myIpCIDR    = "${var.myIp}/32"
}
