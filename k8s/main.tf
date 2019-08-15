terraform {
  required_version = ">= 0.12.3"
}

provider "kubernetes" {
  version = "~> 1.8"
}

resource "kubernetes_namespace" "antaeus" {
  metadata {
    name = "antaeus"
  }
}
