resource "kubernetes_secret" "vault_secret" {
  metadata {
    name = "vault-aws-kms-secrets"
    namespace = var.namespace
  }
  data = {
    access-key = aws_iam_access_key.vault_user_access_key.id
    access-key-secret = aws_iam_access_key.vault_user_access_key.secret
    region = var.region
    kms-id = aws_kms_key.vault_key.id
    table = aws_dynamodb_table.vault_dynamodb_table.name
  }
}

resource "helm_release" "vault" {
  name = "vault"
  chart = "vault"
  repository = "https://helm.releases.hashicorp.com"
  version = var.vault_version
  values = [
    file("${path.module}/values.yaml")]

  namespace = var.namespace
  depends_on = [
    aws_dynamodb_table.vault_dynamodb_table,
    aws_iam_user.vault_user,
    aws_iam_policy.kms_vault_user_policy
  ]
}
