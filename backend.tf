terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.10"
    }
  }

  backend "gcs" {
     bucket = "bucket-skilful-mercury"
  }

  required_version = ">= 1.0"
}


provider "google" {
    project = "skilful-mercury-400917"
}
