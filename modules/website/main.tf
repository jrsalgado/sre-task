resource "aws_launch_template" "webapp_lt" {
  name_prefix                          = "${var.environment}-${var.name}-"
  image_id                             = "${var.image_id}"
  instance_type                        = "${var.instance_type}"
  key_name                             = "${var.key_name}"
  # user_data                          = "${data.template_cloudinit_config.user_data.rendered}"
  instance_initiated_shutdown_behavior = "terminate"
  ebs_optimized                        = false
  network_interfaces {
    associate_public_ip_address        = true
    delete_on_termination              = true
    subnet_id                          = "${element(var.subnet_ids,0)}"
    security_groups                    = ["${aws_security_group.webapp_instance_sg.id}"]
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
  # vpc_id      = "${var.vpc_id}}"
  vpc_id = "vpc-792e0402"

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