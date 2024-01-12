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

resource "google_sql_database_instance" "mysql" {
  database_version = "MYSQL_8_0"
  name = var.name
  region = var.network_region
  settings {
    tier = var.tier
    deletion_protection_enabled = false
    backup_configuration {
      binary_log_enabled = true
      enabled = true
      start_time = var.backup-start
      transaction_log_retention_days = var.retention
      backup_retention_settings {
        retained_backups = var.retention
        retention_unit = "COUNT"
      }
    }
    ip_configuration {
      authorized_networks {
        name = "public"
        value = var.ip-public
      }
    }
  }
}

resource "google_sql_database_instance" "read_replica" {
  database_version = "MYSQL_8_0"
  master_instance_name = google_sql_database_instance.mysql.name
  region = var.network_region
  name = "replica-01"
  depends_on = [ google_sql_database_instance.mysql ]
  settings {
    tier = var.tier
    deletion_protection_enabled = false
    ip_configuration {
      authorized_networks {
        name = "public"
        value = var.ip-public
      }
    }
  }
}

output "ip-database" {
  value = google_sql_database_instance.mysql.public_ip_address
}

resource "google_sql_database" "database" {
  name = var.db-name
  instance = google_sql_database_instance.mysql.name
  depends_on = [ google_sql_database_instance.mysql ]
}

resource "google_sql_user" "user" {
  name = var.db-user
  instance = google_sql_database_instance.mysql.name
  password = var.password
  depends_on = [ google_sql_database_instance.mysql ]
}

resource "null_resource" "grant_privileges" {
  depends_on = [google_sql_database.database, google_sql_user.user]

  provisioner "local-exec" {
    command = "mysql --host=${google_sql_database_instance.mysql.ip_address[0].ip_address} --user=root --password=${var.password} --execute=\"GRANT ALL ON ${var.db-name}.* TO '${var.db-user}'@'%';\""
  }
}
