variable "subnet_db_name" {
  type        = string
  default     = "develop_db"
  description = "db subnet name"
}


variable "zone_db" {
  type        = string
  default     = "ru-central1-d"
  description = "zone for vm_db"
}

variable "cidr_db" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "cidr for subnet_db"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "VM name"
}

variable "vm_db_platform" {
  type        = string
  default     = "standard-v3"
  description = "platform VM"
}

variable "vms_resources" {
  description = "VMs resources"
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }
    db = {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }
  }
}

# variable "vm_db_cores" {
#   type        = number
#   default     = 2
#   description = "cores VM"
# }

# variable "vm_db_memory" {
#   type        = number
#   default     = 2
#   description = "memory VM"
# }

# variable "vm_db_core_fraction" {
#   type        = number
#   default     = 20
#   description = "core fraction VM"
# }

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "preemptible VM"
}

variable "vm_db_nat" {
  type        = bool
  default     = false
  description = "nat VM"
}

# variable "vm_db_serial_port" {
#   type        = number
#   default     = 1
#   description = "serial port VM"
# }

variable "vms_metadata" {
  type = map(object({
    serial_port_enable = number
    ssh_key_path       = string
  }))
  default = {
    common = {
      serial_port_enable = 1
      ssh_key_path       = "~/.ssh/id_ed25519.pub"
    }
  }
}