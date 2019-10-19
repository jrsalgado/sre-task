


module "amis" {
  source = "../../modules/aws_amis"
}

module "vpcs" {
  source = "../../modules/aws_vpcs"
}

module "key_pair" {
  source = "../../modules/aws_key_pairs"
  name       = "${local.environment}-${local.name}-key"
  public_key = "files/ssh_keys/id_rsa.pub"
}

# High Alvailability Website
module "high_availability_website" {
  source      = "../../modules/website"
  ag_size     = "1"
  environment = "${local.environment}"
  name        = "${local.name}"
  image_id    = "${module.amis.ubuntu_bionic}"
  subnet_ids  = ["${module.vpcs.subnet_ids_default}"]
  vpc_id      = "${module.vpcs.vpc_id_default}"
  cidr_blocks = ["${local.myIpCIDR}"]
  key_name    = "${module.key_pair.key_name}"
}
