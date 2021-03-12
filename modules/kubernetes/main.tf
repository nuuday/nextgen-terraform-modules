data "aws_eks_cluster" "this" {
  name = var.cluster_id
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_id
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
}

resource "kubernetes_namespace" "namespaces" {
  for_each = var.namespaces
  metadata {
    name = each.value
  }
}

