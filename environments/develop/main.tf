module "amis" {
  source = "../../modules/aws/amis"
}

module "vpcs" {
  source = "../../modules/aws/vpcs"
}

module "key_pair" {
  source = "../../modules/aws/key_pairs"
  name       = "${local.environment}-${local.name}-key"
  public_key = "${file("files/ssh_keys/id_rsa.pub")}"
}

# High Alvailability Website
module "high_availability_website" {
  source      = "../../modules/aws/website"
  ag_size     = "2"
  environment = "${local.environment}"
  name        = "${local.name}"
  image_id    = "${module.amis.ubuntu_bionic}"
  subnet_ids  = ["${module.vpcs.subnet_ids_default}"]
  vpc_id      = "${module.vpcs.vpc_id_default}"
  cidr_blocks = ["${local.myIpCIDR}"]
  key_name    = "${module.key_pair.key_name}"
}

output "website_dns" {
  value = "http://${module.high_availability_website.website_dns}"
}
