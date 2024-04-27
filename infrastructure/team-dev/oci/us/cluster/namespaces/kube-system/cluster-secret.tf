resource "helm_release" "cluster-secret" {
  name       = "cluster-secret"
  repository = "https://charts.clustersecret.io/"
  chart      = "cluster-secret"
  version    = "0.4.1"
  namespace  = "kube-system"
}
/*
resource "kubernetes_manifest" "registry" {
  manifest = {
    apiVersion = "clustersecret.io/v1"
    kind       = "ClusterSecret"
    metadata = {
      name      = "registry"
      namespace = "kube-system"
    }
    data = {
      ".dockerconfigjson" = base64encode(jsonencode({
        "auths" = {
          "${local.registry.host}" = {
            username = local.registry.username
            password = local.registry.password
            email    = local.registry.email
            auth     = base64encode("${local.registry.username}:${local.registry.password}")
          }
        }
      }))
    }
  }
  depends_on = [
    helm_release.cluster-secret
  ]
}*/
