# =============================================================
# versions.tf — Terraform & Provider Versions
# Projet : AWS 3-Tier Architecture — DeoTech
# Auteur : Decardo Koumous Wouile (Henock Nsakala)
# Date   : Avril 2026
# =============================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "deotech-terraform-state"
    key            = "aws-3tier/terraform.tfstate"
    region         = "eu-west-3"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "aws-3tier-portfolio"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "Decardo Koumous Wouile"
    }
  }
}
