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


resource "google_container_cluster" "my-gke" {
  name = var.name
  location = var.location
  remove_default_node_pool = true
  initial_node_count = 1
  deletion_protection = var.deletion_protection
  node_config {
    labels = {
      kind = "kubernete-master"
      purpose = "rnd"
    }
  }
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "my-node" {
  name = "${var.name}-node-1"
  location = var.location
  cluster = google_container_cluster.my-gke.name
  node_count = 1
  version = "1.27.3-gke.100"
  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }
  upgrade_settings {
    max_surge = 1
  }
  node_config {
    preemptible  = true
    machine_type = var.machine_type
    metadata = {
      disable-legacy-endpoints = "true"
    }
    oauth_scopes = [ "https://www.googleapis.com/auth/cloud-platform" ]
    labels = {
      kind = "kubernetes-pool"
      purpose = "rnd"
    }
  }
  timeouts {
    update = "20m"
    create = "30m"
  }
}