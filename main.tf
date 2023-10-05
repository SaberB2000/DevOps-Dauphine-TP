resource "google_project_service" "ressource_manager" {
    project = "skilful-mercury-400917"
    service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "ressource_usage" {
    service = "serviceusage.googleapis.com"
    depends_on = [ google_project_service.ressource_manager ]
}

/*resource "google_storage_bucket" "bucket-skilful-mercury" {
    name          = "bucket-skilful-mercury" 
    location      = "US"
    force_destroy = true
    depends_on = [ google_project_service.ressource_manager ]
}*/

resource "google_project_service" "sqladmin" {
  service = "sqladmin.googleapis.com"
  depends_on = [ google_project_service.ressource_manager ]
}

resource "google_sql_database" "wordpress" {
  name     = "wordpress"
  instance = "main-instance"
}

resource "google_sql_user" "wordpress" {
   name     = "wordpress"
   instance = "main-instance"
   password = "ilovedevops"
   depends_on = [ google_project_service.sqladmin ]
   
}

resource "google_project_service" "cloudbuild" {
  service = "cloudbuild.googleapis.com"
  depends_on = [ google_project_service.ressource_manager ]
}

resource "google_project_service" "artifact" {
    service = "artifactregistry.googleapis.com"
    depends_on = [ google_project_service.ressource_manager ]
}

resource "google_artifact_registry_repository" "my-repoe" {
  location      = "us-central1"
  repository_id = "exam-repository"
  description   = "Exemple de repo Docker"
  format        = "DOCKER"

  depends_on = [ google_project_service.artifact ]
}

resource "google_cloud_run_service" "default" {
name     = "serveur-wordpress"
location = "us-central1"

template {
   spec {
      containers {
      image = "us-west2-docker.pkg.dev/skilful-mercury-400917/website-tools/exam-image:tag1"
      ports{
        container_port = 80
      }
      }
   }

   metadata {
      annotations = {
            "run.googleapis.com/cloudsql-instances" = "skilful-mercury-400917:us-central1:main-instance"
      }
   }
}

traffic {
   percent         = 100
   latest_revision = true
}
}

data "google_iam_policy" "noauth" {
   binding {
      role = "roles/run.invoker"
      members = [
         "allUsers",
      ]
   }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
   location    = google_cloud_run_service.default.location
   project     = google_cloud_run_service.default.project
   service     = google_cloud_run_service.default.name

   policy_data = data.google_iam_policy.noauth.policy_data
}