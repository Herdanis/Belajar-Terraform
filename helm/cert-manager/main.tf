terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.7.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }
  }
}

provider "google" {
  credentials = file("sa.json")
  project = var.project
  region = var.region
  zone = var.zone
}


data "google_client_config" "config" {
}

data "google_container_cluster" "cluster" {
  name = "my-kubernetes"
  location = var.location
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.cluster.endpoint}"
    token                  = data.google_client_config.config.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
  }
  # kubernetes {
  #   config_path = "~/.kube/config"
  # }
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  create_namespace = true
  version          = "v1.13.2"
  set {
    name  = "installCRDs"
    value = "true"
  }
}