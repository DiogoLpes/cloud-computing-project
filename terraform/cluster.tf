resource "minikube_cluster" "cluster" {
  cluster_name = "cluster-${terraform.workspace}" 
  driver       = "docker"
  memory       = 1024
  cpus         = 2
  addons       = ["ingress", "storage-provisioner", "default-storageclass"]
}