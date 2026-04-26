# =============================================================
# outputs.tf — Sorties du déploiement Terraform
# Projet : AWS 3-Tier Architecture — DeoTech
# Auteur : Decardo Koumous Wouile (Henock Nsakala)
# Date   : Avril 2026
# =============================================================

# --- ALB ---

output "alb_dns_name" {
  description = "DNS public du Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN du Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_zone_id" {
  description = "Zone ID du ALB (utile pour Route 53)"
  value       = aws_lb.main.zone_id
}

# --- URLs du site ---

output "website_url" {
  description = "URL HTTPS du site (domaine apex)"
  value       = "https://${var.domain_name}"
}

output "website_url_www" {
  description = "URL HTTPS du site (www)"
  value       = "https://www.${var.domain_name}"
}

# --- Target Group ---

output "target_group_arn" {
  description = "ARN du Target Group"
  value       = aws_lb_target_group.main.arn
}

output "target_group_arn_suffix" {
  description = "Suffixe ARN du Target Group (utile pour CloudWatch)"
  value       = aws_lb_target_group.main.arn_suffix
}

# --- Auto Scaling Group ---

output "asg_name" {
  description = "Nom de l'Auto Scaling Group"
  value       = aws_autoscaling_group.main.name
}

output "launch_template_id" {
  description = "ID du Launch Template"
  value       = aws_launch_template.main.id
}

# --- SNS ---

output "sns_topic_arn" {
  description = "ARN du SNS Topic pour les alertes"
  value       = aws_sns_topic.alerts.arn
}

# --- Route 53 ---

output "route53_apex_fqdn" {
  description = "FQDN de l'enregistrement Route 53 apex"
  value       = aws_route53_record.apex.fqdn
}

output "route53_www_fqdn" {
  description = "FQDN de l'enregistrement Route 53 www"
  value       = aws_route53_record.www.fqdn
}

# --- Security Groups ---

output "alb_security_group_id" {
  description = "ID du Security Group de l'ALB"
  value       = aws_security_group.alb_sg.id
}

output "ec2_security_group_id" {
  description = "ID du Security Group des instances EC2"
  value       = aws_security_group.ec2_sg.id
}

# --- Résumé déploiement ---

output "deployment_summary" {
  description = "Résumé complet du déploiement Phase 3"
  value = <<-EOT
    ============================================
    DEOTECH - AWS 3-TIER ARCHITECTURE - PHASE 3
    ============================================
    Environnement  : ${var.environment}
    Région AWS     : ${var.aws_region}
    Domaine        : https://${var.domain_name}
    ALB DNS        : ${aws_lb.main.dns_name}
    ASG            : ${aws_autoscaling_group.main.name}
    SNS Topic      : ${aws_sns_topic.alerts.arn}
    ============================================
  EOT
}
