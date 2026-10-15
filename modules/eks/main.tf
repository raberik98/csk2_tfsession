# Master node
resource "aws_eks_cluster" "this" {
  name = var.name
  role_arn = aws_iam_role.cluster.arn
  version = var.k8s_version
  


  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = [ aws_security_group.cluster.id ]
    endpoint_private_access = true
    endpoint_public_access = true // false in prod
    public_access_cidrs = [ "0.0.0.0/0" ]
  }

  depends_on = [ 
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy, 
    aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController
    ]
  
  tags = { Name = "csksession" }
}





resource "terraform_data" "configure_kubectl" {
  count = var.configure_kubectl != {} ? 1 : 0
  depends_on = [aws_eks_cluster.this]

  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region ${var.configure_kubectl.aws_region} --name ${aws_eks_cluster.this.name} --profile ${var.configure_kubectl.aws_cli_profile}
    EOT
  }
}