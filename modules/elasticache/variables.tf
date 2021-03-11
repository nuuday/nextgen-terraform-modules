variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "source_subnet" {}
variable "name" {}
variable "parameter_group" {}

variable "engine" {}
variable "engine_version" {}
variable "node_type" {}
variable "number_of_nodes" {}

variable "tags" {
  type = map(string)
}

