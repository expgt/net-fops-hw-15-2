###cloud vars

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-e"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vm_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "image"
}

variable "env" {
  type        = string
  default     = "develop"
  description = "environment"
}

variable "project" {
  type        = string
  default     = "netology"
  description = "project"
}

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

###ssh vars

# variable "vms_ssh_root_key" {
#   type        = string
#   #default     = "<your_ssh_ed25519_key>"
#   description = "save in terraform.tfvars"
# }

variable "test" {
  description = "List of maps"
  type        = list(map(list(string)))
}