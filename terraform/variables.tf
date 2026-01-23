variable "client_config" {
  type = map(list(string))
  default = {
    airbnb    = ["dev", "prod"]
    nike      = ["dev", "qa", "prod"]
    mcdonalds = ["dev", "qa", "beta", "prod"]
  }
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