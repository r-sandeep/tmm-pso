resource "azurerm_resource_group" "sql_server_rg" {
  name     = "${lower(var.client_name)}-bdd"
  location = "francecentral"
}

resource "azurerm_storage_account" "sql_storage_st" {
  name                     = "${lower(var.client_name)}storagebdd01"
  resource_group_name      = azurerm_resource_group.sql_server_rg.name
  location                 = azurerm_resource_group.sql_server_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "sql_instance_srv" {
  name                         = "${lower(var.client_name)}-instance-sql"
  resource_group_name          = azurerm_resource_group.sql_server_rg.name
  location                     = azurerm_resource_group.sql_server_rg.location
  version                      = "12.0"
  administrator_login          = var.bdd_login
  administrator_login_password = var.bdd_password

}

resource "azurerm_mssql_server_extended_auditing_policy" "sql_instance_srv_policy" {
  server_id                               = azurerm_mssql_server.sql_instance_srv.id
  storage_endpoint                        = azurerm_storage_account.sql_storage_st.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.sql_storage_st.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 6
}


resource "azurerm_mssql_database" "bdd_test" {

    for_each = { for db in var.database_name : db.name => db }

  name                        = each.value.name
  server_id                   = azurerm_mssql_server.sql_instance_srv.id
  collation                   = each.value.collation
  read_scale                  = false
  sku_name                    = "GP_S_Gen5_1"
  zone_redundant              = false
  auto_pause_delay_in_minutes = 60
  min_capacity                = 0.5
}
