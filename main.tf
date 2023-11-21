terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "CICD-case" {
  name         = "gcr.io/Energinet/CICD-case:latest"
  keep_locally = false
}

resource "docker_container" "CICD-case-service" {
  image = docker_image.CICD-case.image_id
  name  = "CICD-case"

  ports {
    internal = 80
    external = 8000
  }
}