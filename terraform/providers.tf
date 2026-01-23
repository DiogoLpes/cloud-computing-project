terraform {
  required_providers {
    minikube = {
      source = "scott-the-programmer/minikube"
      version = "0.4.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

provider "minikube" {
  kubernetes_version = "v1.30.0"
}

provider "kubernetes" {
  host                   = minikube_cluster.cluster.host
  client_certificate     = minikube_cluster.cluster.client_certificate
  client_key             = minikube_cluster.cluster.client_key
  cluster_ca_certificate = minikube_cluster.cluster.cluster_ca_certificate
}