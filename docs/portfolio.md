# 📄 Fiche Projet — AWS 3-Tier Architecture

## 🏢 Contexte

Projet personnel de portfolio réalisé dans le cadre de la préparation à la certification **AWS Solutions Architect Associate (SAA-C03)**.

Objectif : démontrer la maîtrise d'une infrastructure cloud AWS de niveau production, en effectuant une migration réelle depuis un VPS vers AWS.

---

## 🎯 Problématique résolue

| Avant (Phase 1 — VPS) | Après (Phase 2 — AWS) |
|---|---|
| Serveur unique, pas de redondance | Architecture multi-couches sur AWS |
| Déploiement manuel via SSH | Pipeline CI/CD GitHub Actions automatisé |
| Pas de load balancing | ALB avec health checks |
| MySQL local | RDS MySQL managé avec backups |
| Pas d'isolation réseau | VPC avec subnets publics/privés |

---

## 🏗️ Solutions techniques implémentées

### Réseau & Sécurité
- **VPC** dédié avec CIDR 10.0.0.0/16 (région eu-west-3 — Paris)
- **Subnets publics** pour les serveurs web (accès via ALB)
- **Subnets privés** pour l'application et la base de données
- **Security Groups** granulaires par tier
- **IAM Roles** pour accès aux services AWS sans credentials hardcodées

### Tier 1 — Présentation
- **Application Load Balancer** distribue le trafic HTTP
- **Target Groups** avec health checks automatiques
- Instances EC2 dans subnet public

### Tier 2 — Application
- Instances **EC2** dans subnet privé
- Application **Flask** (Python) servie par Gunicorn + Nginx
- Connexion sécurisée à RDS via Security Group

### Tier 3 — Données
- **RDS MySQL** dans subnet privé isolé
- Backups automatiques activés
- Accès restreint au Security Group de l'application

### CI/CD
- **GitHub Actions** : pipeline complet sur push `main`
- Déploiement SSH automatique sur EC2
- Health checks post-déploiement
- Run #24437943470 disponible comme référence

---

## 📊 Résultats & Apprentissages

- Infrastructure fonctionnelle et accessible en production
- Pipeline CI/CD opérationnel avec déploiement automatisé
- Isolation réseau correctement configurée (0 accès direct à la BDD)
- Maîtrise de la console AWS (VPC, EC2, RDS, ALB, Security Groups, IAM)
- Préparation active SAA-C03 : services utilisés en conditions réelles

---

## 🛣️ Prochaines étapes (Phase 3)

- [ ] HTTPS via ACM + Route 53 (domaine custom)
- [ ] Auto Scaling Group pour la résilience
- [ ] CloudWatch Alarms & Dashboards
- [ ] Infrastructure as Code avec Terraform
- [ ] WAF pour la sécurité applicative

---

## 🔗 Liens

- **Repo GitHub** : https://github.com/AnimusKWD/aws-3tier-portfolio
- **Application live** : http://deotech-alb-818502760.eu-west-3.elb.amazonaws.com/
- **CI/CD Pipeline** : https://github.com/AnimusKWD/aws-3tier-portfolio/actions

---

*Decardo Koumous Wouile — Ingénieur Cloud Computing — Tunis, Tunisie — 2025*
