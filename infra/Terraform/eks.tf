resource "aws_eks_cluster" "example" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "null_resource" "connection" {
  depends_on = [aws_eks_cluster.example]
  triggers = {
    build_number = var.build_number
  }
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name my-eks-cluster --region ap-south-2"
  }
}