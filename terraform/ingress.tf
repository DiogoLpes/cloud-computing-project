resource "kubernetes_ingress_v1" "odoo_ingress" {
  for_each = local.instances_map

  depends_on = [
    null_resource.delete_nginx_admission,
    kubernetes_deployment_v1.odoo,
    kubernetes_secret_v1.tls_cert
  ]

  metadata {
    name      = "odoo-ingress"
    namespace = kubernetes_namespace_v1.ns[each.key].metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"
    
    tls {
      hosts       = [each.value.domain]
      secret_name = "odoo-tls-secret" 
    }

    rule {
      host = each.value.domain
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.odoo_service[each.key].metadata[0].name
              port { number = 80 }
            }
          }
        }
      }
    }
  }
}