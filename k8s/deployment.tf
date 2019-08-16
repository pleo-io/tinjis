locals {
        docker_image = format("%s:%s", var.image_name, var.image_version)
}

resource "kubernetes_deployment" "antaeus" {
  metadata {
    name = "app-deploy"
    namespace = "antaeus"
    labels = {
      app = "antaeus"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "antaeus"
      }
    }

    template {
      metadata {
        labels = {
          app = "antaeus"
        }
      }

      spec {
        container {
          image = local.docker_image
          name  = "antaeus"

          env {
            name = "PAYMENT_PROVIDER_ENDPOINT"
            value = "http://payme-svc.payme.svc.cluster.local:9000/pay"
          }

          readiness_probe {
            http_get {
              path = "/rest/health"
              port = 8000
            }

            initial_delay_seconds = 30
            period_seconds        = 15
          }
        }
      }
    }
  }
}
