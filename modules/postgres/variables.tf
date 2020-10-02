variable "cidr_blocks" {
  type = list(string)
}

variable "vpc_id" {}

variable "database_instance_type" {}

variable "database_storage_size" {}

variable "name" {}

variable "user" {}

variable "password" {}

variable "tags" {
  type = map(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "engine_version" {
  type = string
}

variable "major_engine_version" {
  type = string
}

variable "auto_minor_version_upgrade" {
  type = bool
  default = true
}

variable "family" {
  type = string
}

variable "maintenance_window" {
  type = string
}

variable "backup_window" {
  type = string
}

variable "backup_retention_period" {
  type = number
}

variable "multi_az" {
  type = bool
}

variable "deletion_protection" {
  type = bool
}