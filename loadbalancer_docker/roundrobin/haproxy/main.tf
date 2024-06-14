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

resource "docker_image" "haproxy" {
  name = "haproxy:latest"
}

resource "docker_network" "haproxy" {
  name = "haproxy-lb"
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
    external = tonumber("800${count.index}")
    ip       = "0.0.0.0"
  }
  network_mode = docker_network.haproxy.name
}
 
 resource "docker_container" "loadbalancer" {
  name  = "loadbalancer"
  image = docker_image.haproxy.name
  memory = 256
  hostname = "loadbalancer"
  ports {
    internal = 80
    external = 80
    ip       = "0.0.0.0"
  }
  volumes {
    host_path      = "${path.cwd}/haproxy.cfg"
    container_path = "/usr/local/etc/haproxy/haproxy.cfg"
  }
    depends_on = [
    docker_container.backend
  ]
  network_mode = docker_network.haproxy.name
}
