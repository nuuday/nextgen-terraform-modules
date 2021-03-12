output "brokers" {
  value = split(",", aws_msk_cluster.this.bootstrap_brokers)
}

output "brokers_tls" {
  value = split(",", aws_msk_cluster.this.bootstrap_brokers_tls)
}

output "zookeeper" {
  value = split(",", aws_msk_cluster.this.zookeeper_connect_string)
}