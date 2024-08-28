# IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
#### Newly added
# resource "aws_iam_policy" "ec2_network_policy" {
#   name        = "EC2NetworkPolicy"
#   description = "Policy to allow EC2 instances to manage networking for NodePort"
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "ec2:DescribeInstances",
#           "ec2:ModifyInstanceAttribute",
#           "ec2:DescribeSecurityGroups",
#           "ec2:DescribeNetworkInterfaces",
#           "ec2:CreateNetworkInterface",
#           "ec2:DeleteNetworkInterface",
#           "ec2:DescribeVpcs",
#           "ec2:DescribeSubnets",
#           "ec2:AttachNetworkInterface"
#         ],
#         "Resource" : "*"
#       },
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "ec2:AuthorizeSecurityGroupIngress",
#           "ec2:AuthorizeSecurityGroupEgress",
#           "ec2:RevokeSecurityGroupIngress",
#           "ec2:RevokeSecurityGroupEgress"
#         ],
#         "Resource" : "*"
#       }
#     ]
#   })
# }
# resource "aws_iam_role_policy_attachment" "attach_ec2_network_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = aws_iam_policy.ec2_network_policy.arn
# }
#### old content
resource "aws_iam_role_policy_attachment" "eks_node_role_policy_attachment" {
  role       = aws_iam_role.eks_node_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  role       = aws_iam_role.eks_node_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_registry_policy_attachment" {
  role       = aws_iam_role.eks_node_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_node_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# EKS Managed Node Group
resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  #  remote_access {
  #   ec2_ssh_key            = "my_idrsa"
  #   source_security_group_ids = [aws_security_group.eks_cluster_sg.id]
  # }
  depends_on = [aws_iam_role_policy_attachment.eks_node_role_policy_attachment, aws_iam_role_policy_attachment.eks_cni_policy_attachment, aws_iam_role_policy_attachment.eks_registry_policy_attachment,  aws_iam_role.eks_node_role]
  # Specify custom security group
  # launch_template {
  #   id      = aws_launch_template.example.id
  #   version = "$Latest"
  # }

  instance_types = ["t3.small"]

  tags = {
    Name = "my-node-group"
  }
}
# resource "aws_launch_template" "example" {
#   name          = "example"
#   image_id      = "ami-068daf89d1895ab7b"
#   instance_type = "t3.small"
#    network_interfaces {
#     associate_public_ip_address = true
#     security_groups = [aws_security_group.eks_cluster_sg.id]
#   }
#   key_name = "my_idrsa"

  # Attach custom security group
  # vpc_security_group_ids = [aws_security_group.eks_cluster_sg.id]
# }