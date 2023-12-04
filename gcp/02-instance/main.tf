terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.7.0"
    }
  }
  backend "gcs" {
    bucket = "726f585d504767ab-bucket"
    prefix = "terraform/state"
  }
}

provider "google" {
  credentials = file("sa.json")
  project = var.project
  region = var.region
  zone = var.zone
}

resource "google_compute_instance" "personal" {
  name = var.name
  machine_type = "e2-micro"
  tags = [ "ssh" ]
  labels = {
    kind = "instance"
    purpose = "rnd"
  }
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      labels = {
        kind = "disk"
        purpose = "rnd"
      }
    }
  }

  metadata = {
    ssh-keys = "herdanis:${file("~/.ssh/id_ed25519.pub")}"
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_address.static-ip.address}"
    }
    network_ip = "10.138.0.3"
  }
}

resource "google_compute_firewall" "ssh-access" {
  name = "ssh"
  allow {
    ports = ["22"]
    protocol = "tcp"
  }
  network = "default"
  priority = 1000
  direction = "INGRESS"
  source_ranges = [ "0.0.0.0/0" ]
  target_tags = ["ssh"]
}

resource "google_compute_address" "static-ip" {
  name = var.name
  region = var.network_region
  labels = {
    kind = "ip_network"
    purpose = "rnd"
  }
}

output "public-ip" {
  value = google_compute_instance.personal.network_interface[0].access_config[0].nat_ip
}