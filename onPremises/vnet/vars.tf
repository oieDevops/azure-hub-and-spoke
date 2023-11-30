variable "location" {
  type        = string
  description = "Azure region for deployment"
  default     = "eastus"
}

# SPOKE-1 VARIABLE
variable "op_cidr" {
  type        = list(string)
  description = "address space for spoke 1 vnet"
  default     = ["172.0.0.0/16"]
}

variable "op_web" {
  type        = list(string)
  description = "address space for subnet in spoke vnet"
  default     = ["172.0.0.0/20"]
}

variable "op_app" {
  type        = list(string)
  description = "address space for subnet in spoke vnet"
  default     = ["172.0.16.0/20"]
}

variable "op_db" {
  type        = list(string)
  description = "address space for subnet in spoke vnet"
  default     = ["172.0.32.0/20"]
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
