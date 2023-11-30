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
  default     = "Standard_A2_v2"
}

variable "application_port" {
  description = "Port that you want to expose to the external load balancer"
  default     = 443
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


