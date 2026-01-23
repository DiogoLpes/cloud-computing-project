resource "null_resource" "delete_nginx_admission" {
  depends_on = [minikube_cluster.cluster]

  provisioner "local-exec" {
    command = "kubectl delete validatingwebhookconfiguration ingress-nginx-admission --ignore-not-found"
  }
}