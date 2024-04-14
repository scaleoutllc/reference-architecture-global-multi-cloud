resource "kubectl_manifest" "ingress" {
  for_each  = toset(split("---", file("${path.module}/nginx.yml")))
  yaml_body = each.value
}
