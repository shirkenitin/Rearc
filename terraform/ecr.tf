/*
data "aws_iam_policy_document" "ecr_policy" {
  statement {
    sid    = "ECRFullAccessForAccount"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }

}

resource "aws_ecr_repository" "quest" {
  name                 = "${var.environment}-${var.project_name}-quest"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = local.common_tags
}

resource "aws_ecr_repository_policy" "quest" {
  repository = aws_ecr_repository.quest.name
  policy     = data.aws_iam_policy_document.ecr_policy.json
}


resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.quest.name
  policy = jsonencode(
    {
      rules = [{
        rulePriority = 1
        description  = "Retain only the last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }]
    }
  )
}

*/