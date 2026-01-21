# Gera a chave privada para cada instância
resource "tls_private_key" "odoo_key" {
  for_each  = local.instances_map
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Gera o certificado auto-assinado
resource "tls_self_signed_cert" "odoo_cert" {
  for_each        = local.instances_map
  private_key_pem = tls_private_key.odoo_key[each.key].private_key_pem

  subject {
    common_name  = each.value.domain
    organization = "Odoo Project ${each.value.client}"
  }

  validity_period_hours = 8760 # 1 ano

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

# Cria o Secret no Kubernetes para o Ingress usar
resource "kubernetes_secret" "tls_cert" {
  for_each = local.instances_map

  metadata {
    name      = "odoo-tls-secret"
    namespace = kubernetes_namespace.ns[each.key].metadata[0].name
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = tls_self_signed_cert.odoo_cert[each.key].cert_pem
    "tls.key" = tls_private_key.odoo_key[each.key].private_key_pem
  }
}