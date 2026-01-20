variable "clients" {
  description = "Mapa de clientes e seus ambientes"
  type        = map(object({
    environments = list(string)
  }))
}