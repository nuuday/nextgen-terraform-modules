
resource "aws_kms_key" "vault_key" {
  description = "Vault key for ${var.name}"
  key_usage   = "ENCRYPT_DECRYPT"
  tags        = var.common_tags
}

resource "aws_kms_alias" "vault_alias" {
  name          = "alias/${var.kms_name}"
  target_key_id = aws_kms_key.vault_key.id
}

resource "aws_iam_user" "vault_user" {
  name = var.username
  path = "/"
  tags = var.common_tags
}

resource "aws_iam_access_key" "vault_user_access_key" {
  user = aws_iam_user.vault_user.name
}


resource "aws_dynamodb_table" "vault_dynamodb_table" {
  name = var.dynamodb_name
  billing_mode = "PAY_PER_REQUEST"
  tags = var.common_tags
  
  hash_key = "Path"
  range_key = "Key"

  attribute {
    name = "Path"
    type = "S"
  }

  attribute {
    name = "Key"
    type = "S"
  }
}
