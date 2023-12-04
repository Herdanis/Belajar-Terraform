terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.7.0"
    }
  }
}

provider "google" {
  project = var.project
  region = var.region
}


resource "google_service_account" "terraform-account" {
  account_id = var.account_id
  display_name = var.display_name
}

resource "google_service_account_key" "terraform-key" {
  service_account_id = google_service_account.terraform-account.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
  public_key_type    = "TYPE_X509_PEM_FILE"
}

data "google_project" "current" {}


output "project_id" {
  value = data.google_project.current.project_id
}

resource "google_project_iam_member" "terraform-permission" {
  project = data.google_project.current.project_id
  role = var.role
  member = "serviceAccount:${google_service_account.terraform-account.email}"
}

# resource "google_service_account_iam_binding" "terraform-permission" {
#   service_account_id = google_service_account.terraform-account.name
#   role = "roles/editor"
#   members = [ 
#     "serviceAccount:${google_service_account.terraform-account.email}"
#   ]
# }

output "service-account" {
  value = google_service_account_key.terraform-key.private_key
  sensitive = true
}

resource "local_file" "sa-json" {
  filename = "sa.json"
  content = base64decode(google_service_account_key.terraform-key.private_key) 
  depends_on = [ google_service_account_key.terraform-key ]
}