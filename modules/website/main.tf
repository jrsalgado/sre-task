data "template_cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = true

  # setup base
  part {
    filename     = "01_setup_firewall_ssh.sh"
    content_type = "text/x-shellscript"
    content      = "${file("../../common/scripts/setup_firewall_ssh.sh")}"
  }

  # setup webserver
  part {
    filename     = "02_setup_webserver.sh"
    content_type = "text/x-shellscript"
    content      = "${file("${path.module}/files/setup_webserver.sh")}"
  }

}
resource "aws_launch_template" "webapp_lt" {
  name_prefix                          = "${var.environment}-${var.name}-"
  image_id                             = "${var.image_id}"
  instance_type                        = "${var.instance_type}"
  key_name                             = "${var.key_name}"
  user_data                            = "${data.template_cloudinit_config.user_data.rendered}"
  instance_initiated_shutdown_behavior = "terminate"
  ebs_optimized                        = false
  network_interfaces {
    associate_public_ip_address        = true
    delete_on_termination              = true
    subnet_id                          = "${element(var.subnet_ids,0)}"
    security_groups                    = [
      "${aws_security_group.webapp_instance_sg.id}",
      "${aws_security_group.allow_trafic_public_nodes.id}"
      ]
  }
}

resource "aws_autoscaling_group" "webapp_ag" {
  name                      = "${var.environment}-${var.name}-ag"

  max_size                  = "${var.ag_size}"
  desired_capacity          = "${var.ag_size}"
  min_size                  = "${var.ag_size}"

  health_check_type         = "EC2"
  force_delete              = true

  launch_template {
    id      = "${aws_launch_template.webapp_lt.id}"
    version = "$Latest"
  }

  vpc_zone_identifier       = ["${var.subnet_ids}"]

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.name}"
    propagate_at_launch = false
  }

}

resource "aws_security_group" "webapp_instance_sg" {
  name        = "${var.environment}-${var.name}-instance-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = "${var.vpc_id}"
  # vpc_id = "vpc-792e0402"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # $(curl -s http://checkip.amazonaws.com)
    cidr_blocks = ["${var.cidr_blocks}"] # add a CIDR block here
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "allow_trafic_public_nodes" {
  name        = "${var.environment}-${var.name}-alb-instance"
  description = "Allow ALB trafic to nodes"

  vpc_id      = "${var.vpc_id}"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    description = "Nginx HTTP node port"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    security_groups = [ "${aws_security_group.alb_webservers_sg.id}" ]
  }

}