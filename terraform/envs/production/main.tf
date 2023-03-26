terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.57.0"
    }
  }
  backend "gcs" {
    bucket = "project-challenge-tfstate"
    prefix = "terraform/production"
  }
}

provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project_id
  region      = var.region
}

locals {
  services_to_enable = [
    "run.googleapis.com",
    "iamcredentials.googleapis.com",
    "iam.googleapis.com",
  ]
}

resource "google_project_service" "enable_apis" {
  project  = var.project_id
  for_each = toset(local.services_to_enable)

  service                    = each.value
  disable_dependent_services = true
  disable_on_destroy         = false
}

resource "google_service_account" "github-actions" {
  project    = var.project_id
  account_id = "github-actions"
}

resource "google_iam_workload_identity_pool" "github-actions" {
  workload_identity_pool_id = "github-actions"
}

resource "google_iam_workload_identity_pool_provider" "github-actions-provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github-actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-provider"
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

locals {
  github_actions_service_account_email = "serviceAccount:github-actions@${var.project_id}.iam.gserviceaccount.com"
  roles = [
    "roles/run.admin",
    "roles/storage.admin",
    "roles/iam.serviceAccountUser"
  ]
}

resource "google_project_iam_binding" "github-actions-binding" {
  project = var.project_id 
  for_each = toset(local.roles)

  role = each.value
  members = [
    local.github_actions_service_account_email
  ]
}