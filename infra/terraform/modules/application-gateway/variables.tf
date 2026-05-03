variable "name" {
  description = "Application Gateway name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "subnet_id" {
  description = "Application Gateway subnet ID."
  type        = string
}

variable "public_ip_address_id" {
  description = "Public IP address ID for Application Gateway."
  type        = string
}

variable "frontend_private_ip" {
  description = "Frontend VM private IP."
  type        = string
}

variable "backend_private_ip" {
  description = "Backend VM private IP."
  type        = string
}

variable "sonarqube_private_ip" {
  description = "SonarQube VM private IP."
  type        = string
  default     = null
}

variable "enable_sonarqube" {
  description = "Whether to expose SonarQube through Application Gateway."
  type        = bool
  default     = false
}

variable "frontend_port" {
  description = "Frontend backend port."
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Backend API port."
  type        = number
  default     = 8080
}

variable "sonarqube_port" {
  description = "SonarQube port."
  type        = number
  default     = 9000
}

variable "frontend_probe_path" {
  description = "Frontend health probe path."
  type        = string
  default     = "/"
}

variable "backend_probe_path" {
  description = "Backend health probe path."
  type        = string
  default     = "/api/health"
}

variable "sonarqube_probe_path" {
  description = "SonarQube health probe path."
  type        = string
  default     = "/"
}

variable "sku_name" {
  description = "Application Gateway SKU name."
  type        = string
  default     = "WAF_v2"
}

variable "sku_tier" {
  description = "Application Gateway SKU tier."
  type        = string
  default     = "WAF_v2"
}

variable "capacity" {
  description = "Application Gateway instance capacity."
  type        = number
  default     = 1
}

variable "waf_enabled" {
  description = "Enable WAF."
  type        = bool
  default     = true
}

variable "waf_firewall_mode" {
  description = "WAF firewall mode."
  type        = string
  default     = "Prevention"

  validation {
    condition     = contains(["Detection", "Prevention"], var.waf_firewall_mode)
    error_message = "WAF firewall mode must be Detection or Prevention."
  }
}

variable "waf_rule_set_version" {
  description = "OWASP rule set version."
  type        = string
  default     = "3.2"
}

variable "routing_rule_priority" {
  description = "Routing rule priority."
  type        = number
  default     = 100
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}

variable "enable_https" {
  description = "Enable HTTPS listener."
  type        = bool
  default     = false
}

variable "ssl_certificate_key_vault_secret_id" {
  description = "Key Vault secret ID for Application Gateway TLS certificate."
  type        = string
  default     = null
}

variable "host_names" {
  description = "Host names for HTTPS listener."
  type        = list(string)
  default     = []
}

variable "identity_ids" {
  description = "User assigned identity IDs for Application Gateway."
  type        = list(string)
  default     = []
}

variable "sonarqube_host_names" {
  description = "Host names for the optional SonarQube HTTPS listener."
  type        = list(string)
  default     = []
}