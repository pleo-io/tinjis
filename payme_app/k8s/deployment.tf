locals {
	docker_image = format("%s:%s", var.image_name, var.image_version)
}

resource "kubernetes_deployment" "payme" {
  metadata {
    name = "payme-deploy"
    namespace = "payme"
    labels = {
      app = "payme-api"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "payme-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "payme-api"
        }
      }

      spec {
        container {
          image = local.docker_image
          name  = "payme-api"

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = 9000
            }

            initial_delay_seconds = 5
            period_seconds        = 30 
          }
        }
      }
    }
  }
}
