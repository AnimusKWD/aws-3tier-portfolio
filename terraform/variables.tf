# =============================================================
# variables.tf — Variables de configuration
# Projet : AWS 3-Tier Architecture — DeoTech
# Auteur : Decardo Koumous Wouile (Henock Nsakala)
# Date   : Avril 2026
# =============================================================

# --- Région AWS ---
variable "aws_region" {
  description = "Région AWS de déploiement"
  type        = string
  default     = "eu-west-3"
}

# --- Environnement ---
variable "environment" {
  description = "Environnement de déploiement (production/staging)"
  type        = string
  default     = "production"
}

# --- VPC ---
variable "vpc_id" {
  description = "ID du VPC existant"
  type        = string
  default     = "vpc-0a1b2c3d4e5f67890"
}

variable "public_subnet_ids" {
  description = "Liste des IDs des sous-réseaux publics"
  type        = list(string)
  default     = ["subnet-0a1b2c3d4e5f67890", "subnet-0b2c3d4e5f6789012"]
}

variable "private_subnet_ids" {
  description = "Liste des IDs des sous-réseaux privés"
  type        = list(string)
  default     = ["subnet-0c3d4e5f678901234", "subnet-0d4e5f6789012345"]
}

# --- EC2 / ASG ---
variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID pour les instances EC2 (Amazon Linux 2023)"
  type        = string
  default     = "ami-0302f42a44bf53a45"
}

variable "asg_min_size" {
  description = "Nombre minimum d'instances dans l'ASG"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Nombre maximum d'instances dans l'ASG"
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "Capacité désirée de l'ASG"
  type        = number
  default     = 2
}

# --- ALB ---
variable "alb_name" {
  description = "Nom du Application Load Balancer"
  type        = string
  default     = "deotech-alb"
}

# --- ACM ---
variable "acm_certificate_arn" {
  description = "ARN du certificat ACM pour HTTPS"
  type        = string
  default     = "arn:aws:acm:eu-west-3:918630971438:certificate/REPLACE_WITH_REAL_ARN"
}

# --- Route 53 ---
variable "domain_name" {
  description = "Nom de domaine principal"
  type        = string
  default     = "deotech.online"
}

variable "route53_zone_id" {
  description = "ID de la zone Route 53"
  type        = string
  default     = "REPLACE_WITH_ZONE_ID"
}

# --- SNS ---
variable "alert_email" {
  description = "Email pour les alertes CloudWatch via SNS"
  type        = string
  default     = "henock@deotech.online"
}

# --- CloudWatch ---
variable "cpu_alarm_threshold" {
  description = "Seuil CPU (%) pour déclencher l'alarme CloudWatch"
  type        = number
  default     = 80
}

variable "unhealthy_hosts_threshold" {
  description = "Nombre de cibles défaillantes pour déclencher l'alarme"
  type        = number
  default     = 1
}
