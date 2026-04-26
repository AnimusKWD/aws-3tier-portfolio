# =============================================================
# main.tf — Ressources principales Terraform
# Projet : AWS 3-Tier Architecture — DeoTech
# Auteur : Decardo Koumous Wouile (Henock Nsakala)
# Date   : Avril 2026
# =============================================================
# Ressources : ALB, Listeners, Target Group, ASG,
#              Launch Template, Route 53, SNS, CloudWatch
# =============================================================

# --- DATA SOURCES ---

data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

# --- SECURITY GROUP : ALB ---

resource "aws_security_group" "alb_sg" {
  name        = "deotech-alb-sg"
  description = "Security Group pour Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP depuis Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS depuis Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "deotech-alb-sg"
  }
}

# --- SECURITY GROUP : EC2 ---

resource "aws_security_group" "ec2_sg" {
  name        = "deotech-ec2-sg"
  description = "Security Group pour instances EC2 (trafic ALB uniquement)"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP depuis ALB uniquement"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "deotech-ec2-sg"
  }
}

# --- APPLICATION LOAD BALANCER ---

resource "aws_lb" "main" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = var.alb_name
  }
}

# --- TARGET GROUP ---

resource "aws_lb_target_group" "main" {
  name     = "deotech-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/health.php"
    matcher             = "200"
  }

  tags = {
    Name = "deotech-tg"
  }
}

# --- LISTENER HTTP (redirect vers HTTPS) ---

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# --- LISTENER HTTPS ---

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# --- LAUNCH TEMPLATE ---

resource "aws_launch_template" "main" {
  name_prefix   = "deotech-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd php php-mysqli
    systemctl start httpd
    systemctl enable httpd
    echo "<?php echo 'OK'; ?>" > /var/www/html/health.php
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "deotech-web-server"
      Environment = var.environment
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# --- AUTO SCALING GROUP ---

resource "aws_autoscaling_group" "main" {
  name                      = "deotech-asg"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = [aws_lb_target_group.main.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "deotech-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# --- ASG SCALING POLICIES ---

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "deotech-scale-up"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "deotech-scale-down"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}

# --- SNS TOPIC ---

resource "aws_sns_topic" "alerts" {
  name = "deotech-alerts-sns"

  tags = {
    Name = "deotech-alerts-sns"
  }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# --- CLOUDWATCH ALARMS ---

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "deotech-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = var.cpu_alarm_threshold
  alarm_description   = "CPU > 80% pendant 4 minutes"
  alarm_actions       = [aws_sns_topic.alerts.arn, aws_autoscaling_policy.scale_up.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "deotech-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "CPU < 20% - Scale Down"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }
}

resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts" {
  alarm_name          = "deotech-unhealthy-hosts"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = var.unhealthy_hosts_threshold
  alarm_description   = "Alerte : cibles défaillantes détectées dans le Target Group"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
    TargetGroup  = aws_lb_target_group.main.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "deotech-alb-5xx"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "Alerte : erreurs 5xx sur ALB > 10 en 1 minute"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }
}

# --- ROUTE 53 RECORDS ---

resource "aws_route53_record" "apex" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}
