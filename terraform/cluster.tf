resource "minikube_cluster" "cluster" {
  for_each     = local.instances_map
  cluster_name = each.value.instance_id
  driver       = "docker"
  memory       = 1024
  cpus         = 1
  addons       = ["ingress", "storage-provisioner", "default-storageclass"]
}

