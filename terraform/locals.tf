locals {
  # Filtra o cliente atual com base no workspace selecionado
  client_name = terraform.workspace
  client_data = var.clients[local.client_name]

  # Cria o mapa de ambientes para este cliente específico
  instances_map = {
    for env in local.client_data.environments : 
    env => {
      namespace = "${local.client_name}-${env}"
      domain    = "odoo.${env}.${local.client_name}.local"
      env_name  = env
    }
  }
}