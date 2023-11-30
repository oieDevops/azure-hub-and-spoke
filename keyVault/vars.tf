variable "location" {
  type        = string
  description = "Azure region for deployment"
  default     = "eastus"
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

variable "vault_name" {
  type        = string
  description = "Azure region for deployment"
  default     = "oie"
}