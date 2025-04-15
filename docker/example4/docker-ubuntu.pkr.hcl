// Treat Packer variables as constants — you cannot update them during run time.

variable "docker_image" {
  type = string
}

variable "deployed_by" {
  type = string
}


packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = var.docker_image
  commit = true
}

source "docker" "ubuntu-focal" {
  image  = "ubuntu:focal"
  commit = true
}


build {
  name = "learn-packer"
  sources = [
    "source.docker.ubuntu",
    "source.docker.ubuntu-focal"
  ]
  provisioner "shell" {
    environment_vars = [
      "FOO=hello world, My name is ${var.deployed_by}",
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }

  provisioner "shell" {
    inline = ["echo Running $(cat /etc/os-release | grep VERSION= | sed 's/\"//g' | sed 's/VERSION=//g') Docker image."]
  }

}


