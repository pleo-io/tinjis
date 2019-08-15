resource "kubernetes_role" "antaeus" {
  metadata {
    name = "deploy"
    namespace = "antaeus"
    }
  }

  rule {
    api_groups     = [""]
    resources      = ["pods"]
    resource_names = [""]
    verbs          = ["*"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding" "antaeus" {
  metadata {
    name      = "deploy-binding"
    namespace = "antaeus"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "deploy"
  }
  subject {
    kind      = "User"
    name      = "deploy"
    api_group = "rbac.authorization.k8s.io"
  }
}
