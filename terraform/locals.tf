locals {
  # Busca a lista de ambientes (ex: ["dev", "prod"]) para o workspace atual
  ambientes_do_cliente = lookup(var.client_config, terraform.workspace, [])

  # Cria o mapa que todos os recursos usam no for_each
  instances_map = {
    for env in local.ambientes_do_cliente : env => {
      namespace = "${terraform.workspace}-${env}"
      domain    = "odoo.${env}.${terraform.workspace}.local"
      client    = terraform.workspace
    }
  }
}