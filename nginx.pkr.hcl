packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "nginx" {
  image  = "nginx:latest"
  commit = true
}

build {
  sources = ["source.docker.nginx"]

  # On s'assure de supprimer le fichier par défaut avant de mettre le nôtre
  provisioner "shell" {
    inline = ["rm /usr/share/nginx/html/index.html"]
  }

  provisioner "file" {
    source      = "index.html"
    destination = "/usr/share/nginx/html/index.html"
  }

  provisioner "shell" {
    inline = ["chmod 644 /usr/share/nginx/html/index.html"]
  }

  post-processor "docker-tag" {
    repository = "nginx-custom"
    tags       = ["latest"]
  }
}