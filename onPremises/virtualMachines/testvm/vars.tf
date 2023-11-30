# VM VARS
variable "username" {
  description = "Username for Virtual Machines"
  default     = "pVerifyadmin"
}

variable "password" {
  description = "Password for Virtual Machines"
}

variable "vmsize" {
  description = "Size of the VMs"
  default     = "Standard_DS1_v2"
}

variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    Owner              = "pVerify"
    Environment        = "sandbox"
    Workload           = "infra-networking"
    CostAndUsage       = "finOps"
    ManagedByTerraform = "True"
  }
}

# AUTH VARIABLE
variable "client_id" {
  type        = string
  description = "used to authenticate to Azure"
}

variable "client_secret" {
  type        = string
  description = "used to authenticate to Azure"
}

variable "subscription_id" {
  type        = string
  description = "used to authenticate to Azure"
}

variable "tenant_id" {
  type        = string
  description = "used to authenticate to Azure"
}