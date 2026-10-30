# data "http" "lbc_iam_policy" {
#   url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.17.1/docs/install/iam_policy.json"
# }

data "aws_iam_policy_document" "lbc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_policy" "lbc" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Official policy for the AWS Load Balancer Controller"
  policy = file("./modules/eks/loadbalancer_controller.json")
}

resource "aws_iam_role" "lbc" {
  name               = "${aws_eks_cluster.this.name}-aws-lbc"
  assume_role_policy = data.aws_iam_policy_document.lbc.json
}

resource "aws_iam_role_policy_attachment" "lbc" {
  role       = aws_iam_role.lbc.name
  policy_arn = aws_iam_policy.lbc.arn
}

resource "aws_eks_pod_identity_association" "lbc" {
  cluster_name    = aws_eks_cluster.this.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.lbc.arn
}

resource "helm_release" "lbc" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.8.1" # Align this with your desired chart version

  set = [{
        name  = "clusterName"
        value = aws_eks_cluster.this.name
    }, {
      name  = "region"
      value = var.aws_region
    },{
        name  = "serviceAccount.name"
        value = "aws-load-balancer-controller"
    }, {
      name  = "serviceAccount.create"
      value = "true"
    },{
        name  = "vpcId"
        value = var.vpc_id
    }]

  depends_on = [aws_eks_pod_identity_association.lbc]
}