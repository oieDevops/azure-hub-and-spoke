variable "location" {
  type        = string
  description = "Azure region for deployment"
  default     = "eastus"
}

# HUB VARIABLE
variable "vnet" {
  type        = list(string)
  description = "address space for hub vnet"
  default     = ["10.0.0.0/16"]
}

variable "gateway" {
  type        = list(string)
  description = "address space for subnet in hub vnet"
  default     = ["10.0.8.0/21"]
}

variable "firewall" {
  type        = list(string)
  description = "address space for subnet in hub vnet"
  default     = ["10.0.16.0/21"]
}

variable "mgmt" {
  type        = list(string)
  description = "address space for subnet in hub vnet"
  default     = ["10.0.24.0/21"]
}

variable "bastion" {
  type        = list(string)
  description = "address space for subnet in hub vnet"
  default     = ["10.0.254.0/26"]
}

variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    Owner              = "oie"
    Environment        = "dev"
    Workload           = "networking"
    CostAndUsage       = "finOps"
    ManagedByTerraform = "True"
  }
}