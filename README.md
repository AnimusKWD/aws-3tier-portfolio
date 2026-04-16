# 🚀 AWS 3-Tier Architecture — Portfolio Project

> **Decardo Koumous Wouile** · Ingénieur Cloud Computing, Virtualisation & Automatisation  
> 📍 Tunis, Tunisie · [LinkedIn](https://www.linkedin.com/in/decardo-koumous-wouile/) · [🌐 Application en ligne](http://deotech-alb-818502760.eu-west-3.elb.amazonaws.com/) · [![WhatsApp](https://img.shields.io/badge/WhatsApp-Contact-25D366?style=flat&logo=whatsapp&logoColor=white)](https://wa.me/21626885727)

---

## 📊 Métriques du projet

| Indicateur | Valeur |
|---|---|
| ☁️ Cloud Provider | AWS (eu-west-3 — Paris) |
| 🏗️ Architecture | 3 tiers (Web / App / BDD) |
| 🔄 CI/CD | GitHub Actions (Pipeline actif) |
| 🗄️ Base de données | RDS MySQL (Multi-AZ ready) |
| ⚖️ Load Balancer | Application Load Balancer (ALB) |
| 🔒 Sécurité | VPC, Security Groups, IAM Roles |
| 📅 Durée projet | Phase 1 (VPS) → Phase 2 (AWS Migration) |

---

## 🎯 Objectif

Ce projet démontre ma capacité à concevoir, déployer et automatiser une infrastructure cloud AWS de production, organisée en **3 couches distinctes** :

- **Tier 1 — Présentation** : Serveurs web EC2 derrière un ALB (Application Load Balancer)
- **Tier 2 — Application** : Logique métier sur instances EC2 dédiées en subnet privé
- **Tier 3 — Données** : Base de données RDS MySQL isolée dans un subnet privé

Ce projet illustre une migration réelle : **VPS → Cloud AWS**, avec mise en place d'un pipeline CI/CD complet via GitHub Actions.

---

## 🏗️ Architecture AWS

```
┌─────────────────────────────────────────────────────────────┐
│                    VPC (10.0.0.0/16)                        │
│                    Region: eu-west-3                        │
│                                                             │
│  ┌──────────────┐         ┌──────────────────────────────┐  │
│  │  Public       │         │  Internet Gateway            │  │
│  │  Subnet       │◄───────►│  ALB (Application LB)        │  │
│  │  (Web Tier)   │         └──────────────────────────────┘  │
│  └──────┬───────┘                                            │
│         │                                                   │
│  ┌──────▼───────┐                                           │
│  │  Private      │                                          │
│  │  Subnet       │  EC2 Instances (App Tier)                │
│  │  (App Tier)   │                                          │
│  └──────┬───────┘                                           │
│         │                                                   │
│  ┌──────▼───────┐                                           │
│  │  Private      │                                          │
│  │  Subnet       │  RDS MySQL (Data Tier)                   │
│  │  (Data Tier)  │                                          │
│  └──────────────┘                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Stack Technique

### ☁️ Cloud AWS
`EC2` `RDS MySQL` `VPC` `ALB` `Security Groups` `IAM` `CloudWatch` `S3`

### 🔄 CI/CD
`GitHub Actions` `SSH Deploy` `Automated Tests` `Health Checks`

### 💻 Application
`Python / Flask` `Nginx` `Gunicorn` `MySQL Connector`

### 🔒 Sécurité
`VPC Isolation` `Private Subnets` `Security Groups` `IAM Roles` `SSH Keys`

---

## 📁 Structure du projet

```
aws-3tier-portfolio/
├── .github/
│   └── workflows/
│       └── deploy.yml          # Pipeline CI/CD GitHub Actions
├── app/
│   ├── app.py                  # Application Flask principale
│   ├── requirements.txt        # Dépendances Python
│   └── templates/              # Templates HTML
├── scripts/
│   ├── setup-web.sh            # Script config serveur web
│   └── setup-db.sh             # Script config base de données
├── screenshots/                # Captures AWS Console
├── Architecture.jpeg           # Schéma architecture
└── README.md
```

---

## 🔄 Pipeline CI/CD — GitHub Actions

Le pipeline se déclenche automatiquement à chaque `push` sur `main` :

```yaml
Phases du pipeline :
  1. 🔍 Checkout du code
  2. 🧪 Tests unitaires (Python)
  3. 🔐 Connexion SSH sécurisée vers EC2
  4. 📦 Déploiement de l'application
  5. 🔁 Redémarrage des services (Gunicorn/Nginx)
  6. ✅ Health Check de l'application
```

[![CI/CD Status](https://github.com/AnimusKWD/aws-3tier-portfolio/actions/workflows/deploy.yml/badge.svg)](https://github.com/AnimusKWD/aws-3tier-portfolio/actions)

🔗 **Dernier run CI/CD** : [Run #24437943470](https://github.com/AnimusKWD/aws-3tier-portfolio/actions/runs/24437943470)

---

## 🚀 Phases du projet

### Phase 1 — Infrastructure VPS (Origine)
- Hébergement sur VPS dédié
- Déploiement manuel via SSH
- Application Flask + MySQL sur serveur unique
- Monitoring basique

### Phase 2 — Migration AWS (Actuelle)
- Migration complète vers AWS eu-west-3 (Paris)
- Architecture 3-tier avec VPC dédié
- Application Load Balancer pour la haute disponibilité
- RDS MySQL managé avec backups automatiques
- Pipeline CI/CD GitHub Actions opérationnel
- Security Groups et IAM roles configurés

### Phase 3 — Optimisation (En cours)
- [ ] HTTPS avec ACM + Route 53
- [ ] Auto Scaling Group (ASG)
- [ ] CloudWatch Alarms & Dashboards
- [ ] Infrastructure as Code (Terraform)
- [ ] WAF pour la sécurité applicative

---

## 🌐 Application en production

🔗 **URL publique** : http://deotech-alb-818502760.eu-west-3.elb.amazonaws.com/

> Application Flask démontrant la connectivité entre les 3 tiers et l'état de l'infrastructure.

---

## 📸 Captures d'écran

Les captures de la console AWS (VPC, EC2, RDS, ALB, Security Groups) sont disponibles dans le dossier [`/screenshots`](./screenshots).

---

## 🏅 Certifications en cours

- ⏳ **AWS Certified Solutions Architect — Associate (SAA-C03)** — En préparation
- ✅ AWS Cloud Practitioner (Fondamentaux cloud maîtrisés)

---

## 👤 Auteur

**Decardo Koumous Wouile**  
Ingénieur Cloud Computing, Virtualisation & Automatisation  
📍 Tunis, Tunisie

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/decardo-koumous-wouile/)
[![GitHub](https://img.shields.io/badge/GitHub-AnimusKWD-black?style=flat&logo=github)](https://github.com/AnimusKWD)
[![WhatsApp](https://img.shields.io/badge/WhatsApp-Contact-25D366?style=flat&logo=whatsapp&logoColor=white)](https://wa.me/21626885727)

---

*Projet réalisé dans le cadre du développement de mon portfolio Cloud & DevOps — 2025*
