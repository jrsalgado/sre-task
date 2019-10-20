resource "aws_alb" "webserver_alb" {
  name                = "${var.environment}-${var.name}-alb"
  subnets             = ["${var.subnet_ids}"]
  security_groups     = ["${aws_security_group.alb_webservers_sg.*.id}"]
  load_balancer_type  = "application"

  tags {
    Name               = "${var.environment}-${var.name}-alb"
    Environment        = "${var.environment}"
  }
}

resource "aws_security_group" "alb_webservers_sg" {
  name         = "${var.environment}-${var.name}-alb-ws-sg"
  description  = "Allow trafic from ALB to webserver nodes"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.webapp_instance_sg.id}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${var.environment}-${var.name}-alb-ws-sg"
    Environment = "${var.environment}"
  }
}