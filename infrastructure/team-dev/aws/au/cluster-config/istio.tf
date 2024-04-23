data "helm_template" "istio-crds" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = "1.21.1"
  namespace  = "istio-system"
  set {
    name  = "base.enableCRDTemplates"
    value = true
  }
  show_only = [
    "templates/crds.yaml",
  ]
}

data "kubectl_file_documents" "istio-crds" {
  content = data.helm_template.istio-crds.manifest
}

resource "kubectl_manifest" "istio-crds" {
  for_each  = data.kubectl_file_documents.istio-crds.manifests
  yaml_body = each.value
}

resource "helm_release" "istiod" {
  name             = "istiod"
  version          = "1.21.1"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = "istio-system"
  create_namespace = true
  depends_on = [
    kubectl_manifest.istio-crds
  ]
  values = [<<YAML
pilot:
  nodeSelector:
    node.wescaleout.cloud/routing: "true"
  tolerations:
  - key: node.wescaleout.cloud/routing
    operator: Equal
    value: "true"
    effect: NoSchedule
YAML
  ]
}

resource "helm_release" "istio-gateway" {
  name       = "istio-gateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = "istio-system"
  version    = "1.21.1"
  values = [<<YAML
replicaCount: 3
nodeSelector:
  node.wescaleout.cloud/routing: "true"
tolerations:
- key: node.wescaleout.cloud/routing
  operator: Equal
  value: "true"
  effect: NoSchedule
topologySpreadConstraints:
- maxSkew: 1
  topologyKey: topology.kubernetes.io/zone
  whenUnsatisfiable: ScheduleAnyway
  labelSelector:
    matchLabels:
      app: hello
service:
  type: NodePort
  ports:
  - name: status-port
    nodePort: 30021
    port: 15021
    targetPort: 15021
  - name: http
    nodePort: 30080
    port: 80
    targetPort: 80
YAML
  ]
  depends_on = [
    helm_release.istiod
  ]
}

data "kubectl_file_documents" "hello" {
  content = file("${path.module}/hello.yml")
}

resource "kubectl_manifest" "hello" {
  for_each  = data.kubectl_file_documents.hello.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.istio-gateway
  ]
}
