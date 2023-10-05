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
