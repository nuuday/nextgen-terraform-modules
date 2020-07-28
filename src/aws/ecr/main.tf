resource "aws_ecr_repository" "repository" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags                 = var.common_tags
}

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.repository.name
  policy = <<EOF
    {
      "Statement": [
        {
          "Action": [
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetAuthorizationToken"
          ],
          "Principal": {
            "AWS": [
              "${var.principal}"
            ]
          },
          "Effect": "Allow",
          "Sid": "Allow pull"
        }
      ],
      "Version": "2008-10-17"
    }
    EOF
}