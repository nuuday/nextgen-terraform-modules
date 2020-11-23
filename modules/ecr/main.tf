resource "aws_ecr_repository" "repository" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.common_tags
}

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.repository.name
  policy     = <<EOF
    {
      "Statement": [
        {
          "Action": [
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetAuthorizationToken"
          ],
          "Principal": {
            "AWS": ${jsonencode(var.principals)}
          },
          "Effect": "Allow",
          "Sid": "Allow pull"
        }
      ],
      "Version": "2008-10-17"
    }
    EOF
}

resource "aws_ecr_lifecycle_policy" "this" {
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "keep the last 5 production images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 5
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 5
        description  = "keep the last 5 stable images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["stable-"]
          countType     = "imageCountMoreThan"
          countNumber   = 5
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 100
        description  = "other images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 15
        }
        action = {
          type = "expire"
        }
      },
    ]
  })

  repository = aws_ecr_repository.repository.name
}