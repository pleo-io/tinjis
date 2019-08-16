resource "kubernetes_service" "payme-svc" {
  metadata {
    name = "payme-svc"
    namespace = "payme"
  }
  spec {
    selector = {
      app = kubernetes_deployment.payme.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 9000
      target_port = 9000
    }

    type = "NodePort"
  }
}
