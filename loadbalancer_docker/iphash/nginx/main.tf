terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.1"
    }
  }
}

provider "docker" {
  #host = "tcp://localhost:2375"
   host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_network" "nginx" {
  name = "nginx-lb"
  driver = "bridge"
}

resource "docker_container" "backend" {
  count = 3
  name  = "backend${count.index}"
  image = docker_image.nginx.name
  memory = 256
  hostname = "backend${count.index}"
  ports {
    internal = 80
    external = tonumber("808${count.index}")
    ip       = "0.0.0.0"
  }
  network_mode = docker_network.nginx.name
}

resource "docker_container" "loadbalancer" {
  name  = "loadbalancer"
  image = docker_image.nginx.name
  memory = 256
  hostname = "loadbalancer"
  ports {
    internal = 80
    external = 80
    ip       = "0.0.0.0"
  }
  volumes {
    host_path      = "${path.cwd}/nginx.conf"
    container_path = "/etc/nginx/nginx.conf"
  }
    depends_on = [
    docker_container.backend
  ]
  network_mode = docker_network.nginx.name
}
