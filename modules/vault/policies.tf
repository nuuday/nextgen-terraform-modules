resource "aws_iam_user_policy_attachment" "vault_user_policy" {
  policy_arn = aws_iam_policy.kms_vault_user_policy.arn
  user = aws_iam_user.vault_user.name
}

resource "aws_iam_policy" "kms_vault_user_policy" {
  name = "${var.username}-to-kms-policy"
  policy = data.aws_iam_policy_document.kms_use.json
}

data "aws_iam_policy_document" "kms_use" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = [
      aws_kms_key.vault_key.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:ListTables",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:CreateTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:Scan",
      "dynamodb:DescribeTable"
    ]
    resources = [
      aws_dynamodb_table.vault_dynamodb_table.arn
    ]
  }
}
