terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.25.2"
    }
  }
}

provider "digitalocean" {
  token = "dop_v1_12ca668056e3215500947951253662d2bd4d105b0cb35631a7ec1ae8b4eb4e74"
}


resource "digitalocean_droplet" "jenkins" {
  image    = "ubuntu-22-04-x64"
  name     = "jenkins"
  region   = "nyc1"
  size     = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh_keys.id]
}

data "digitalocean_ssh_key" "ssh_keys" {
  name = "Jornada DevOps"
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  name   = "k8s"
  region = "nyc1"
  version = "1.25.4-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 2

  }
}

output "jenkins_ip" {
    value = digitalocean_droplet.jenkins.ipv4_address
}

resource "local_file" "foo" {
    content = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
    filename = "kube_config.yaml"
  
}