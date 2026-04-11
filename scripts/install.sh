#!/bin/bash

# =============================================================
# install.sh - Script d'installation du serveur web sur EC2
# AWS 3-Tier Architecture Project
# Auteur : AnimusK7 (Decardo Koumous Wouile)
# =============================================================

set -e

echo "[1/5] Mise a jour du systeme..."
sudo yum update -y

echo "[2/5] Installation d'Apache..."
sudo yum install -y httpd

echo "[3/5] Installation de PHP et du module MySQL..."
sudo yum install -y php php-mysqlnd php-fpm

echo "[4/5] Demarrage et activation d'Apache au boot..."
sudo systemctl start httpd
sudo systemctl enable httpd

echo "[5/5] Configuration des permissions..."
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;

echo ""
echo "=========================================="
echo " Installation terminee avec succes!"
echo " Apache + PHP installes et demarres."
echo " Deployer l'app : sudo cp app/index.php /var/www/html/"
echo "=========================================="
