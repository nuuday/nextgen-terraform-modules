
variable "cluster_name" {}

variable "kafka_version" {}

variable "number_of_brokers" { 
  type = number
}

variable "ebs_volume_size" {
  type = number
}

variable "instance_size" {
  type = string
}

variable "vpc_id" {}

variable "subnet_ids" {
  type = list(string)
}

variable "source_subnet" {
}

variable "TLS_SETTING" {
  type = string
  description = "TLS setting for client broker, can be: TLS, TLS_PLAINTEXT or PLAINTEXT "
}

