output "application_urls" {
  value = [for inst in local.instances : "https://${inst.domain}"]
}