variable "cluster_id" {
  type = string
}

variable "name" {
  type = string
}

variable "username" {
  type = string
}

variable "kms_name" {
  type = string
}

variable "dynamodb_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "region" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "vault_version" {
  description = "The version of the hashicorp vault helm chart"
}