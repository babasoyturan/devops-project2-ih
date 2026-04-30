resource "azurerm_log_analytics_workspace" "this" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.log_analytics_sku
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}

resource "azurerm_application_insights" "this" {
  name                = var.application_insights_name
  resource_group_name = var.resource_group_name
  location            = var.location
  workspace_id        = azurerm_log_analytics_workspace.this.id
  application_type    = "web"
  tags                = var.tags
}

resource "azurerm_monitor_action_group" "this" {
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.action_group_short_name
  tags                = var.tags

  email_receiver {
    name                    = "primary-email"
    email_address           = var.alert_email_address
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_metric_alert" "app_gateway_unhealthy_hosts" {
  name                = "alert-${var.name_prefix}-agw-unhealthy-hosts"
  resource_group_name = var.resource_group_name
  scopes              = [var.application_gateway_id]
  description         = "Application Gateway has one or more unhealthy backend hosts for at least 5 minutes."
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"
  enabled             = true
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "UnhealthyHostCount"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 0
  }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }
}

resource "azurerm_monitor_metric_alert" "vm_high_cpu" {
  name                     = "alert-${var.name_prefix}-vm-high-cpu"
  resource_group_name      = var.resource_group_name
  scopes                   = var.vm_ids
  target_resource_type     = "Microsoft.Compute/virtualMachines"
  target_resource_location = var.location
  description              = "One or more VMs have average CPU usage greater than ${var.vm_cpu_threshold}% for at least 5 minutes."
  severity                 = 3
  frequency                = "PT1M"
  window_size              = "PT5M"
  enabled                  = true
  tags                     = var.tags

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.vm_cpu_threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }
}

resource "azurerm_monitor_metric_alert" "sql_high_dtu" {
  name                = "alert-${var.name_prefix}-sql-high-dtu"
  resource_group_name = var.resource_group_name
  scopes              = [var.sql_database_id]
  description         = "SQL Database DTU consumption is greater than ${var.sql_dtu_threshold}% for at least 5 minutes."
  severity            = 3
  frequency           = "PT1M"
  window_size         = "PT5M"
  enabled             = true
  tags                = var.tags

  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = "dtu_consumption_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.sql_dtu_threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }
}