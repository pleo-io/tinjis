resource "kubernetes_network_policy" "payme-nacl" {
  metadata {
    name      = "payme-nacl"
    namespace = "payme"
  }

  spec {
    pod_selector {}
    ingress {
      ports {
        port     = "9000"
        protocol = "TCP"
      }

      from {
        namespace_selector {
          match_labels = {
            name = "antaeus"
          }
        }
      }
    }

    egress {} # single empty rule to allow all egress traffic

    policy_types = ["Ingress", "Egress"]
  }
}
