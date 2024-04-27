resource "helm_release" "istio-base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = "1.21.1"
  namespace        = "istio-system"
  create_namespace = true
}

resource "helm_release" "istiod" {
  name       = "istiod"
  version    = "1.21.1"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
  depends_on = [
    helm_release.istio-base
  ]
  values = [<<YAML
pilot:
  nodeSelector:
    node.kubernetes.io/routing: "true"
  tolerations:
  - key: node.kubernetes.io/routing
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
autoscaling:
  enabled: false
replicaCount: 3
nodeSelector:
  node.kubernetes.io/routing: "true"
tolerations:
- key: node.kubernetes.io/routing
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
