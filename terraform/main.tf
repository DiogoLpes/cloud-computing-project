# 1. NAMESPACE
resource "kubernetes_namespace_v1" "ns" {
  for_each = local.instances_map
  metadata {
    name = each.value.namespace
  }
}

# 2. DATABASE SERVICE (Acesso interno ao Postgres)
resource "kubernetes_service" "postgres_service" {
  for_each = local.instances_map

  metadata {
    name      = "db-service"
    namespace = kubernetes_namespace_v1.ns[each.key].metadata[0].name
  }

  spec {
    selector = { app = "postgres" }
    port {
      port        = 5432
      target_port = 5432
    }
  }
}

# 3. DATABASE (PostgreSQL StatefulSet)
resource "kubernetes_stateful_set" "postgres" {
  for_each = local.instances_map

  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace_v1.ns[each.key].metadata[0].name
  }

  spec {
    service_name = "db-service"
    replicas     = 1
    selector { match_labels = { app = "postgres" } }

    template {
      metadata { labels = { app = "postgres" } }
      spec {
        container {
          name  = "postgres"
          image = "postgres:15-alpine"

          resources {
            limits = {
              cpu    = "0.2"
              memory = "256Mi"
            }
            requests = {
              cpu    = "0.1"
              memory = "128Mi"
            }
            
          }
          env {
            name  = "POSTGRES_DB"
            value = "postgres"
          }
          env {
            name  = "POSTGRES_USER"
            value = "odoo"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = "odoo"
          }
          
          port { container_port = 5432 }
          
          volume_mount {
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
          }
        }
      }
    }

    volume_claim_template {
      metadata { name = "postgres-storage" }
      spec {
        access_modes = ["ReadWriteOnce"]
        storage_class_name = "standard"
        resources { requests = { storage = "4096Gi" } }
      }
    }
  }
}

# 4. ODOO DEPLOYMENT 
resource "kubernetes_deployment_v1" "odoo" {
  for_each = local.instances_map

  metadata {
    name      = "odoo"
    namespace = kubernetes_namespace_v1.ns[each.key].metadata[0].name
  }

  spec {
    replicas = 1
    selector { match_labels = { app = "odoo" } }

    template {
      metadata { labels = { app = "odoo" } }
      spec {
        container {
          name  = "odoo"
          image = "odoo:16.0"
          env {
            name  = "HOST"
            value = "db-service"
          }
          
          env {
            name  = "USER"
            value = var.db_user
          }
          
          env {
            name  = "PASSWORD"
            value = var.db_password
          }

          port { container_port = 8069 }
        }
      }
    }
  }
}

# 5. ODOO SERVICE (Expõe o backend internamente para o Ingress)
resource "kubernetes_service" "odoo_service" {
  for_each = local.instances_map

  metadata {
    name      = "odoo-service"
    namespace = kubernetes_namespace_v1.ns[each.key].metadata[0].name
  }

  spec {
    selector = { app = "odoo" }
    port {
      port        = 80
      target_port = 8069
    }
    type = "ClusterIP"
  }
}

