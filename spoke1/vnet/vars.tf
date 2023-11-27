variable "location" {
  type        = string
  description = "Azure region for deployment"
  default     = "eastus"
}

# SPOKE-1 VARIABLE
variable "vnet" {
  type        = list(string)
  description = "address space for spoke 1 vnet"
  default     = ["17.0.0.0/16"]
}

variable "web" {
  type        = list(string)
  description = "address space for subnet in spoke vnet"
  default     = ["17.0.0.0/20"]
}

variable "app" {
  type        = list(string)
  description = "address space for subnet in spoke vnet"
  default     = ["17.0.16.0/20"]
}

variable "db" {
  type        = list(string)
  description = "address space for subnet in spoke vnet"
  default     = ["17.0.32.0/20"]
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
