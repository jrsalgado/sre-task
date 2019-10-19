resource "aws_launch_configuration" "webapp_lc" {
  image_id = "${var.image_id}"
  instance_type = "${var.instance_type}"
}
resource "aws_autoscaling_group" "webapp_lc" {
  name                      = "${var.environment}-${var.name}-ag"

  max_size                  = "${var.ag_size}"
  desired_capacity          = "${var.ag_size}"
  min_size                  = "${var.ag_size}"

  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.webapp_lc.name}"
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
