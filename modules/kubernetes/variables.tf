variable "cluster_id" {
  type = string
  description = "name/id of the EKS cluster which will be connected to"
}

variable "namespaces" {
  type = set(string)
  description = "namespaces to create in the cluster"
}

variable "install_dev_tools" {
  type = bool
  description = "Whether to install our devtools or not"
  default = false
}

