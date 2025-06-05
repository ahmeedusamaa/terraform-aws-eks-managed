resource "aws_ecr_repository" "ecr-front" {
  name = "ecr-front"
}

resource "aws_ecr_repository" "ecr-back" {
  name = "ecr-back"
}
