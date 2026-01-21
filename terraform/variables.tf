variable "clients" {
  description = "Mapa de clientes e seus ambientes"
  type = map(object({
    environments = list(string)
  }))
}


variable "db_user" {
  default = "odoo"
}

variable "db_password" {
  type = string
  default = "odoo"
}


variable "db_name" {
  default = "postgres"
}