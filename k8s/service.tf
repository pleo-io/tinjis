resource "kubernetes_service" "antaeus-svc" {
  metadata {
    name = "antaeus-svc"
    namespace = "antaeus"
  }
  spec {
    selector = {
      //app = "${kubernetes_pod.example.metadata.0.labels.app}"
      app = kubernetes_deployment.antaeus.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 8000
      target_port = 8000
    }

    type = "NodePort"
  }
}
