# Terraform — AWS 3-Tier Architecture (Phase 3)

> **Auteur** : Decardo Koumous Wouile (Henock Nsakala)  
> **Projet** : aws-3tier-portfolio  
> **Date** : Avril 2026  
> **Region AWS** : `eu-west-3` (Paris)

---

## Description

Ce dossier contient l'ensemble du code **Infrastructure as Code (IaC)** Terraform pour la **Phase 3** du projet AWS 3-Tier Architecture. Il permet de provisionner et gérer automatiquement l'infrastructure AWS de façon reproductible et versionnée.

## Architecture provisionnée

```
Internet
    |
[Route 53] deotech.online / www.deotech.online
    |
[ALB] Application Load Balancer (HTTP -> HTTPS redirect)
    |         |
    |    [ACM Certificate TLS 1.3]
    |
[Target Group] Health Check /health.php
    |
[Auto Scaling Group] min=1 / desired=2 / max=4
    |         |
[EC2 t2.micro]  [EC2 t2.micro]   (Private Subnets)
    |
[RDS MySQL] (Phase 2 - existant)
    |
[SNS + CloudWatch Alarms]
```

## Structure des fichiers

| Fichier | Description |
|---------|-------------|
| `versions.tf` | Versions Terraform et provider AWS, configuration backend S3 |
| `variables.tf` | Toutes les variables paramétrables du projet |
| `main.tf` | Ressources principales : ALB, ASG, Launch Template, Route 53, SNS, CloudWatch |
| `outputs.tf` | Sorties : DNS ALB, URLs site, ARN, résumé déploiement |

## Prérequis

- [Terraform](https://www.terraform.io/downloads) >= 1.5.0
- AWS CLI configuré avec les droits suffisants
- Un bucket S3 `deotech-terraform-state` pour le remote state
- Une table DynamoDB `terraform-state-lock` pour le state locking
- Certificat ACM validé pour `deotech.online` en `eu-west-3`
- Zone Route 53 configurée pour `deotech.online`

## Variables à configurer

Avant de déployer, mettez à jour ces valeurs dans `variables.tf` :

| Variable | Valeur à remplacer |
|----------|--------------------|
| `vpc_id` | ID réel du VPC |
| `public_subnet_ids` | IDs des subnets publics |
| `private_subnet_ids` | IDs des subnets privés |
| `acm_certificate_arn` | ARN du certificat ACM |
| `route53_zone_id` | ID de la zone Route 53 |

## Commandes de déploiement

```bash
# 1. Initialiser Terraform
terraform init

# 2. Valider la syntaxe
terraform validate

# 3. Formater le code
terraform fmt

# 4. Planifier les changements
terraform plan -out=tfplan

# 5. Appliquer l'infrastructure
terraform apply tfplan

# 6. Afficher les outputs
terraform output

# 7. Detruire l'infrastructure (si necessaire)
terraform destroy
```

## Ressources Terraform créées

### Networking & Security
- `aws_security_group.alb_sg` — SG pour l'ALB (ports 80/443 publics)
- `aws_security_group.ec2_sg` — SG pour EC2 (port 80 depuis ALB uniquement)

### Load Balancing
- `aws_lb.main` — Application Load Balancer public
- `aws_lb_target_group.main` — Target Group avec Health Check `/health.php`
- `aws_lb_listener.http` — Listener HTTP 80 avec redirect 301 vers HTTPS
- `aws_lb_listener.https` — Listener HTTPS 443 avec certificat ACM TLS 1.3

### Compute & Auto Scaling
- `aws_launch_template.main` — Template EC2 (Amazon Linux 2023, Apache, PHP)
- `aws_autoscaling_group.main` — ASG avec health check ELB
- `aws_autoscaling_policy.scale_up` — Politique scale-up +1 instance
- `aws_autoscaling_policy.scale_down` — Politique scale-down -1 instance

### DNS
- `aws_route53_record.apex` — Alias A record pour `deotech.online`
- `aws_route53_record.www` — Alias A record pour `www.deotech.online`

### Monitoring & Alertes
- `aws_sns_topic.alerts` — Topic SNS pour les alertes email
- `aws_sns_topic_subscription.email` — Abonnement email au topic SNS
- `aws_cloudwatch_metric_alarm.cpu_high` — Alarme CPU > 80%
- `aws_cloudwatch_metric_alarm.cpu_low` — Alarme CPU < 20% (scale-down)
- `aws_cloudwatch_metric_alarm.unhealthy_hosts` — Alarme cibles défaillantes
- `aws_cloudwatch_metric_alarm.alb_5xx` — Alarme erreurs 5xx sur ALB

## Remote State S3

Le state Terraform est stocké de façon sécurisée dans S3 avec verrouillage DynamoDB :

```
Bucket  : deotech-terraform-state
Key     : aws-3tier/terraform.tfstate
Region  : eu-west-3
Encrypt : true
Lock    : terraform-state-lock (DynamoDB)
```

---

*Projet réalisé dans le cadre du Portfolio Cloud & DevOps — Decardo Koumous Wouile*
