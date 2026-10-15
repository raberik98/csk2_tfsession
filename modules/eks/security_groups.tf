resource "aws_security_group" "cluster" {
  name        = "cluster"
  description = "EKS cluster control plane security group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {}
}

resource "aws_security_group" "node" {
  name        = "node"
  description = "EKS worker node security group"
  vpc_id      = var.vpc_id

  tags = {}
}

resource "aws_security_group_rule" "cluster_to_node_kubelet" {
  type                     = "egress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.node.id
  description              = "Control plane to kubelet"
}

resource "aws_security_group_rule" "cluster_to_node_nodeport" {
  type                     = "egress"
  from_port                = 30000
  to_port                  = 32767
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.node.id
  description              = "Control plane to NodePort range"
}