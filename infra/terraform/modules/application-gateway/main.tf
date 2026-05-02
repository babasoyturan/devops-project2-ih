locals {
  frontend_ip_configuration_name = "appgw-frontend-ip"
  frontend_port_http_name        = "port-http-80"
  listener_http_name             = "listener-http"
  gateway_ip_configuration_name  = "appgw-ip-config"

  frontend_pool_name = "pool-frontend"
  backend_pool_name  = "pool-backend"
  sonar_pool_name    = "pool-sonarqube"

  frontend_http_settings_name = "http-settings-frontend"
  backend_http_settings_name  = "http-settings-backend"
  sonar_http_settings_name    = "http-settings-sonarqube"

  frontend_probe_name = "probe-frontend"
  backend_probe_name  = "probe-backend"
  sonar_probe_name    = "probe-sonarqube"

  url_path_map_name = "path-map-main"
  routing_rule_name = "rule-main"

  frontend_port_https_name    = "port-https-443"
  listener_https_name         = "listener-https"
  ssl_certificate_name        = "cert-keyvault"
  redirect_configuration_name = "redirect-http-to-https"
  http_routing_rule_name      = "rule-http-redirect"
  https_routing_rule_name     = "rule-https-main"
}

resource "azurerm_application_gateway" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  dynamic "identity" {
    for_each = length(var.identity_ids) > 0 ? [1] : []

    content {
      type         = "UserAssigned"
      identity_ids = var.identity_ids
    }
  }

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.capacity
  }

  waf_configuration {
    enabled          = var.waf_enabled
    firewall_mode    = var.waf_firewall_mode
    rule_set_type    = "OWASP"
    rule_set_version = var.waf_rule_set_version
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = var.public_ip_address_id
  }

  dynamic "ssl_certificate" {
    for_each = var.enable_https ? [1] : []

    content {
      name                = local.ssl_certificate_name
      key_vault_secret_id = var.ssl_certificate_key_vault_secret_id
    }
  }

  frontend_port {
    name = local.frontend_port_http_name
    port = 80
  }

  dynamic "frontend_port" {
    for_each = var.enable_https ? [1] : []

    content {
      name = local.frontend_port_https_name
      port = 443
    }
  }

  backend_address_pool {
    name         = local.frontend_pool_name
    ip_addresses = [var.frontend_private_ip]
  }

  backend_address_pool {
    name         = local.backend_pool_name
    ip_addresses = [var.backend_private_ip]
  }

  dynamic "backend_address_pool" {
    for_each = var.enable_sonarqube ? [1] : []

    content {
      name         = local.sonar_pool_name
      ip_addresses = [var.sonarqube_private_ip]
    }
  }

  probe {
    name                = local.frontend_probe_name
    protocol            = "Http"
    host                = "127.0.0.1"
    path                = var.frontend_probe_path
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
  }

  probe {
    name                = local.backend_probe_name
    protocol            = "Http"
    host                = "127.0.0.1"
    path                = var.backend_probe_path
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
  }

  dynamic "probe" {
    for_each = var.enable_sonarqube ? [1] : []

    content {
      name                = local.sonar_probe_name
      protocol            = "Http"
      host                = "127.0.0.1"
      path                = var.sonarqube_probe_path
      interval            = 30
      timeout             = 30
      unhealthy_threshold = 3
    }
  }

  backend_http_settings {
    name                  = local.frontend_http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = var.frontend_port
    protocol              = "Http"
    request_timeout       = 30
    probe_name            = local.frontend_probe_name
  }

  backend_http_settings {
    name                  = local.backend_http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = var.backend_port
    protocol              = "Http"
    request_timeout       = 30
    probe_name            = local.backend_probe_name
  }

  dynamic "backend_http_settings" {
    for_each = var.enable_sonarqube ? [1] : []

    content {
      name                  = local.sonar_http_settings_name
      cookie_based_affinity = "Disabled"
      port                  = var.sonarqube_port
      protocol              = "Http"
      request_timeout       = 30
      probe_name            = local.sonar_probe_name
    }
  }

  http_listener {
    name                           = local.listener_http_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_http_name
    protocol                       = "Http"
  }

  dynamic "http_listener" {
    for_each = var.enable_https ? [1] : []

    content {
      name                           = local.listener_https_name
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.frontend_port_https_name
      protocol                       = "Https"
      ssl_certificate_name           = local.ssl_certificate_name
      host_names                     = var.host_names
    }
  }

  url_path_map {
    name                               = local.url_path_map_name
    default_backend_address_pool_name  = local.frontend_pool_name
    default_backend_http_settings_name = local.frontend_http_settings_name

    path_rule {
      name                       = "path-rule-api"
      paths                      = ["/api/*"]
      backend_address_pool_name  = local.backend_pool_name
      backend_http_settings_name = local.backend_http_settings_name
    }

    dynamic "path_rule" {
      for_each = var.enable_sonarqube ? [1] : []

      content {
        name                       = "path-rule-sonarqube"
        paths                      = ["/sonar/*"]
        backend_address_pool_name  = local.sonar_pool_name
        backend_http_settings_name = local.sonar_http_settings_name
      }
    }
  }

  dynamic "redirect_configuration" {
    for_each = var.enable_https ? [1] : []

    content {
      name                 = local.redirect_configuration_name
      redirect_type        = "Permanent"
      target_listener_name = local.listener_https_name
      include_path         = true
      include_query_string = true
    }
  }

  request_routing_rule {
    name               = var.enable_https ? local.http_routing_rule_name : local.routing_rule_name
    rule_type          = var.enable_https ? "Basic" : "PathBasedRouting"
    http_listener_name = local.listener_http_name
    url_path_map_name  = var.enable_https ? null : local.url_path_map_name
    priority           = var.routing_rule_priority

    redirect_configuration_name = var.enable_https ? local.redirect_configuration_name : null
  }

  dynamic "request_routing_rule" {
    for_each = var.enable_https ? [1] : []

    content {
      name               = local.https_routing_rule_name
      rule_type          = "PathBasedRouting"
      http_listener_name = local.listener_https_name
      url_path_map_name  = local.url_path_map_name
      priority           = var.routing_rule_priority + 1
    }
  }
}