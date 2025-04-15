// Plugin
packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

// Source Configuration
source "docker" "ubuntu" {
  image  = "ubuntu:jammy"
  commit = true
}

// Build Process
build {
  name = "learn-packer"
  sources = [
    "source.docker.ubuntu"
  ]
}
