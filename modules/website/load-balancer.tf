resource "aws_alb" "webserver_alb" {
  name                = "${var.environment}-${var.name}-alb"
  subnets             = ["${var.subnet_ids}"]
  security_groups     = ["${aws_security_group.alb_webservers_sg.*.id}"]
  load_balancer_type  = "application"

  tags {
    Name               = "${var.environment}-${var.name}-alb"
    Environment        = "${var.environment}"
  }

  timeouts {
    create = "20m"
  }
}

resource "aws_security_group" "alb_webservers_sg" {
  name         = "${var.environment}-${var.name}-alb-ws-sg"
  description  = "Allow trafic from ALB to webserver nodes"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks =  [ "0.0.0.0/0" ]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${var.environment}-${var.name}-alb-ws-sg"
    Environment = "${var.environment}"
  }
}

resource "aws_autoscaling_attachment" "public_to_webserver" {
  autoscaling_group_name = "${var.environment}-${var.name}-ag"
  alb_target_group_arn   = "${aws_alb_target_group.webserver_tg.arn}"
}

resource "aws_alb_target_group" "webserver_tg" {
  name        = "${var.environment}-${var.name}-ws-http-tg"
  port        = "80"
  vpc_id      = "${var.vpc_id}"
  protocol    = "HTTP"
  target_type = "instance"
  deregistration_delay = 0

  tags {
    name = "${var.environment}-${var.name}-ws-http-tg"
  }
  
  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
  }

  lifecycle {
   ignore_changes = "lambda_multi_value_headers_enabled"
 }
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = "${aws_alb.webserver_alb.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.webserver_tg.arn}"
  }
}