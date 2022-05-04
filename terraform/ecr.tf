resource "aws_ecr_repository" "petclinic" {
  name                 = "${var.image_repo_name}-${var.stack}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
data "aws_ecr_repository" "image_repo" {
  name = "${var.image_repo_name}-${var.stack}"

  depends_on = [
    aws_ecr_repository.petclinic
  ]
}

