provider "google" {
  # credentials = file("keys/gcp-tf-key_2.json")

  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "vpc" {
  source  = "./modules/global"
  env     = var.env
  network = var.network
}

module "instances" {
  source    = "./modules/dev"
  disk_size = var.disk_size
  zone      = var.zone
  network   = var.network
}