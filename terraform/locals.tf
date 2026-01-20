locals {
  instances = flatten([
    for client, data in var.clients : [
      for env in data.environments : {
        client      = client
        env         = env
        instance_id = "${client}-${env}"
        domain      = "odoo.${env}.${client}.local"
      }
    ]
  ])

  instances_map = { for inst in local.instances : inst.instance_id => inst }
}