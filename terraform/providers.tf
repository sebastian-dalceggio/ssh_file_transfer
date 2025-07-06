provider "aws" {
  profile = "default"
}

provider "google" {
  project     = local.envs["GC_PROJECT"]
  region      = local.envs["GC_REGION"]
  credentials = local.envs["GC_CREDENTIALS"]
}