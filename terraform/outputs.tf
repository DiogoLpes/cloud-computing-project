output "application_urls" {
  description = "URLs de acesso para o cliente atual"
  value = [for key, inst in local.instances_map : "https://${inst.domain}"]
}