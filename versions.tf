terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.31"
    }
  }
}

provider "google" {
  project = var.project_id
}