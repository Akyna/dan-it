provider "aws" {
  region = var.region
  # profile = "danit" # FIX for auth - примусовий вибір коли є проблеми з декількома профілями
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  create_namespace = "true"
  chart      = "argo-cd"
  version    = "5.1.0"
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "server.ingress.enabled"
    value = "true"
  }

  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "server.ingress.hosts[0]"
    value = "argocd.${var.cluster_name}.${var.domain_name}"
  }

  set {
    name  = "server.extraArgs"
    # Set extraArgs in argo-cd helm chart with terraform - https://ismailyenigul.medium.com/set-extraargs-in-argo-cd-helm-chart-with-terrraform-b86a972c4223
    value = "{--insecure}" # Важливо для парсингу JSON "{--insecure}" а не "--insecure"
  }



  # Примусовий редирект - але не спрацював :)
  # set {
  #   name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/ssl-redirect"
  #   value = "false"
  # }
  #
  # set {
  #   name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/force-ssl-redirect"
  #   value = "false"
  # }
}

