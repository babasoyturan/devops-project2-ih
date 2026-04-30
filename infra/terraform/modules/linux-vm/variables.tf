variable "name" {
  description = "Linux VM name."
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
  description = "Subnet ID for the VM NIC."
  type        = string
}

variable "vm_size" {
  description = "Azure VM size."
  type        = string
}

variable "admin_username" {
  description = "Admin username for the Linux VM."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for the admin user."
  type        = string
  sensitive   = true
}

variable "os_disk_storage_account_type" {
  description = "OS disk storage account type."
  type        = string
  default     = "Standard_LRS"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}