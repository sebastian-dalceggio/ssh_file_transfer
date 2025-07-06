resource "google_storage_bucket" "gc_cloud_storage" {
  name          = local.envs["GC_BUCKET_NAME"]
  location      = local.envs["GC_REGION"]
  storage_class = "STANDARD"
  project       = local.envs["GC_PROJECT"]

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }
  force_destroy = true

  uniform_bucket_level_access = true

  public_access_prevention = "enforced"

  labels = {
    name    = "gc_cloud_storage"
    project = var.project_name
  }
}
