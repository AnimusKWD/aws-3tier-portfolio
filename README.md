# AWS 3-Tier Architecture Project 🚀

## 📌 Description

Ce projet démontre le déploiement manuel d'une architecture cloud sécurisée et scalable sur AWS, organisée en 3 tiers distincts : accès, application et base de données.

Tout est configuré manuellement via la console AWS, sans outil d'infrastructure as code.

---

## 🧱 Architecture

![Architecture]Architecture.jpeg)

L'architecture repose sur un VPC isolé avec des subnets publics et privés, un Load Balancer exposé sur Internet, des instances EC2 en backend, et une base de données RDS MySQL entièrement isolée du trafic public.

---

## 🗂️ Structure du projet

```
aws-3tier-portfolio/
|
|-- app/
|   |-- index.php
|
|-- scripts/
|   |-- install.sh
|
|-- README.md
|-- architecture.png
```

---

## ☁️ Composants AWS

| Composant | Role |
|---|---|
| VPC | Reseau isole pour tout l'environnement |
| Internet Gateway | Acces Internet entrant vers le subnet public |
| NAT Gateway | Acces Internet sortant depuis le subnet prive |
| Application Load Balancer | Distribution du trafic HTTP vers les EC2 |
| EC2 (Web Server) | Hebergement de l'application PHP |
| RDS MySQL | Base de donnees en subnet prive |
| Security Groups | Controle des flux reseau entre chaque composant |

---

## ⚙️ Etapes de deploiement

### 1. VPC et sous-reseaux
- Creer un VPC avec CIDR `10.0.0.0/16`
- Subnets :
  - **Public** : `10.0.1.0/24` pour l'ALB
  - **Prive** : `10.0.2.0/24` pour RDS

### 2. Connectivite reseau
- Attacher une **Internet Gateway** au VPC
- Creer une **NAT Gateway** dans le subnet public
- Configurer les **tables de routage**

### 3. Security Groups
- **SG-ALB** : port 80 depuis Internet
- **SG-EC2** : port 80 depuis SG-ALB uniquement
- **SG-RDS** : port 3306 depuis SG-EC2 uniquement

### 4. EC2
- Instance Amazon Linux 2 dans le subnet public
- Installation Apache + PHP :

```bash
bash scripts/install.sh
```

- Deploiement de l'application :

```bash
sudo cp app/index.php /var/www/html/index.php
```

### 5. RDS MySQL
- Instance RDS MySQL dans le subnet prive
- Acces public desactive
- Associer SG-RDS

### 6. Application Load Balancer
- ALB dans les subnets publics
- Target Group pointant vers EC2
- Listener sur le port 80

---

## 🎯 Resultat

L'application est accessible via :

```
http://<ALB-DNS-Name>
```

La base de donnees RDS reste isolee dans le subnet prive, accessible uniquement depuis EC2.

---

## 💼 Competences demontrees

- Conception et segmentation d'un VPC AWS
- Gestion des Security Groups et du routage reseau
- Deploiement d'une application PHP sur EC2
- Configuration d'une base de donnees RDS MySQL managee
- Mise en place d'un Application Load Balancer
- Securisation d'une architecture multi-tiers sur AWS

---

## 👤 Auteur

**Decardo Koumous Wouile (AnimusK7)**
Cloud & DevOps Enthusiast | Tunis, Tunisia
[GitHub](https://github.com/AnimusKWD)
