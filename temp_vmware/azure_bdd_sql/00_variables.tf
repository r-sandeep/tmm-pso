variable "client_name" {
  type = string

}

variable "database_name" {
  type = list(object({
    name      = string
    collation = string
  }))
  default = [
    {
      "name" = "db1",
      "collation" = "SQL_Latin1_General_CP1_CI_AS"
    },
    {
      "name" = "db2",
      "collation" = "SQL_Latin1_General_CP1_CI_AS"
    }
  ]
}

variable "bdd_login" {
  type = string

}

variable "bdd_password" {
  type = string

}
