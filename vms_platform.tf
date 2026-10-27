

#-------------------web-----------------------#

# variable "vm_web_name" {
#   type        = string
#   default     = "netology-develop-platform-web"
#   description = "VM name"
# }

variable "vm_web_platform" {
  type        = string
  default     = "standard-v3"
  description = "platform VM"
}

# variable "vm_web_cores" {
#   type        = number
#   default     = "2"
#   description = "cores VM"
# }

# variable "vm_web_memory" {
#   type        = number
#   default     = "1"
#   description = "memory VM"
# }

# variable "vm_web_core_fraction" {
#   type        = number
#   default     = "20"
#   description = "core fraction VM"
# }

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "preemptible VM"
}

variable "vm_web_nat" {
  type        = bool
  default     = false
  description = "nat VM"
}

# variable "vm_web_serial_port" {
#   type        = number
#   default     = "1"
#   description = "serial port VM"
# }


#-------------------db-----------------------#

# variable "vm_db_name" {
#   type        = string
#   default     = "netology-develop-platform-db"
#   description = "VM name"
# }

variable "vm_db_platform" {
  type        = string
  default     = "standard-v3"
  description = "platform VM"
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


#---------------------map---------------------#

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
      memory        = 2
      core_fraction = 20
    }
  }
}

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