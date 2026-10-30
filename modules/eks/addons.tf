resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name      = aws_eks_cluster.this.name
  addon_name        = "eks-pod-identity-agent"
  # addon_version               = try(var.addon_versions.vpc_cni, null)
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [ aws_eks_node_group.this ]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "vpc-cni"
  # addon_version               = try(var.addon_versions.vpc_cni, null)
  resolve_conflicts_on_update = "OVERWRITE"

  pod_identity_association {
    role_arn        = aws_iam_role.vpc_cni_pod_identity.arn # You must create this role
    service_account = "aws-node"
  }

  depends_on = [ aws_eks_node_group.this ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "coredns"
  # addon_version               = try(var.addon_versions.coredns, null)
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [ aws_eks_node_group.this ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "kube-proxy"
  # addon_version               = try(var.addon_versions.kube_proxy, null)
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [ aws_eks_node_group.this ]
}