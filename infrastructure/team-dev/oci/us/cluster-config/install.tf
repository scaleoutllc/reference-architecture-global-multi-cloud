resource "kubectl_manifest" "ingress" {
  for_each  = toset(split("---", file("${path.module}/manifests/nginx-ingress/nginx.yml")))
  yaml_body = each.value
}
