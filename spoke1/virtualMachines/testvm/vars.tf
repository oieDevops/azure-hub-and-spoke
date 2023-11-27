variable "location" {
  type        = string
  description = "Azure region for deployment"
  default     = "eastus"
}

# VM VARS
variable "username" {
  description = "Username for Virtual Machines"
  default     = "oieAdmin"
}

variable "vmsize" {
  description = "Size of the VMs"
  default     = "Standard_A1_v2"
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
