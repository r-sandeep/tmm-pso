variable "client_name" {
  type = string

}

variable "database_name" {
  type = list(object({
    name      = string
    collation = string
  }))
}

variable "bdd_login" {
  type = string

}

variable "bdd_password" {
  type = string

}
