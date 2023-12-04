terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.7.0"
    }
  }
}

provider "google" {
  credentials = file("sa.json")
  project = var.project
  region = var.region
  zone = var.zone
}


resource "google_service_account" "bucket-account" {
  account_id = var.account_id
  display_name = var.display_name
}

resource "google_service_account_key" "bucket-key" {
  service_account_id = google_service_account.bucket-account.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
  public_key_type    = "TYPE_X509_PEM_FILE"
}


resource "local_file" "sa-json" {
  filename = "bucket-sa.json"
  content = base64decode(google_service_account_key.bucket-key.private_key) 
  depends_on = [ google_service_account_key.bucket-key ]
}

resource "random_id" "prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "bucket" {
  name = "${random_id.prefix.hex}-bucket"
  location = var.location
  force_destroy = true
  versioning {
    enabled = true
  }
  uniform_bucket_level_access = true
  labels = {
    kind = "bucket"
    purpose = "rnd"
  }
}

output "bukcet-url" {
  value = google_storage_bucket.bucket.self_link
}

resource "google_storage_bucket_iam_member" "sa-member" {
  depends_on = [ google_service_account.bucket-account ]
  bucket = google_storage_bucket.bucket.name
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.bucket-account.email}"
}