


module "amis" {
  source = "../../modules/aws_amis"
}

module "vpcs" {
  source = "../../modules/aws_vpcs"
}

# High Alvailability Website
module "high_availability_website" {
  source      = "../../modules/website"
  ag_size     = "1"
  environment = "${local.environment}"
  name        = "${local.name}"
  image_id    = "${module.amis.ubuntu_bionic}"
  subnet_ids  = "${module.vpcs.subnet_ids_default}"
  vpc_id      = "${module.vpcs.vpc_id_default}"
}
