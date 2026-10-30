# AL2023_ARM_64_STANDARD	Amazon Linux 2023, ARM (Graviton)
# AL2023_x86_64_NVIDIA	AL2023 with NVIDIA drivers
# AL2023_x86_64_NEURON	AL2023 with AWS Neuron (Inferentia/Trainium)
# AL2_x86_64	Amazon Linux 2 (deprecated, EOL Nov 2025)
# AL2_x86_64_GPU	AL2 with GPU support
# AL2_ARM_64	AL2 on ARM
# BOTTLEROCKET_x86_64	Bottlerocket, x86_64
# BOTTLEROCKET_ARM_64	Bottlerocket, ARM
# BOTTLEROCKET_x86_64_NVIDIA	Bottlerocket with NVIDIA drivers
# BOTTLEROCKET_ARM_64_NVIDIA	Bottlerocket with NVIDIA drivers, ARM
# WINDOWS_CORE_2019_x86_64	Windows Server 2019 Core
# WINDOWS_FULL_2019_x86_64	Windows Server 2019 Full
# WINDOWS_CORE_2022_x86_64	Windows Server 2022 Core
# WINDOWS_FULL_2022_x86_64	Windows Server 2022 Full
# CUSTOM	Bring your own AMI (via launch template)

resource "aws_eks_node_group" "this" {
  for_each = local.node_groups

  cluster_name = aws_eks_cluster.this.name
  node_role_arn = aws_iam_role.node.arn
  subnet_ids = each.value.subnet_ids

  ami_type = "BOTTLEROCKET_x86_64"
  instance_types = [ "c5ad.xlarge" ]
  node_group_name = each.value.name
  capacity_type = "ON_DEMAND"
  disk_size = 20

  scaling_config {
    desired_size = 3
    min_size = 2
    max_size = 15
  }

  labels = each.value.labels
  
}