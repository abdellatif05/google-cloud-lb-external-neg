resource "google_project_service" "apis" {
  for_each = toset([
    "compute.googleapis.com", # Compute Engine API
    "iam.googleapis.com",     # IAM API
  ])

  service            = each.key
  disable_on_destroy = false # Prevents accidental disabling of APIs
}

resource "time_sleep" "wait_for_apis" {
  depends_on      = [google_project_service.apis]
  create_duration = "60s"
}