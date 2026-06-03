resource "kubernetes_deployment_v1" "minio" {
  metadata {
    name      = "minio"
    namespace = var.namespace

    labels = {
      app = "minio"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "minio"
      }
    }

    template {
      metadata {
        labels = {
          app = "minio"
        }
      }

      spec {
        container {
          name  = "minio"
          image = var.images.minio
          args  = ["server", "/data", "--console-address", ":9001"]

          port {
            container_port = 9000
            name           = "api"
          }

          port {
            container_port = 9001
            name           = "console"
          }

          env {
            name  = "MINIO_ROOT_USER"
            value = "minioadmin"
          }

          env {
            name  = "MINIO_ROOT_PASSWORD"
            value = "minioadmin"
          }

          resources {
            requests = {
              memory = "256Mi"
              cpu    = "100m"
            }

            limits = {
              memory = "512Mi"
              cpu    = "200m"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "minio" {
  metadata {
    name      = "minio"
    namespace = var.namespace
  }

  spec {
    type = "NodePort"

    selector = {
      app = "minio"
    }

    port {
      name        = "api"
      port        = 9000
      target_port = 9000
      node_port   = var.minio_api_node_port
    }

    port {
      name        = "console"
      port        = 9001
      target_port = 9001
      node_port   = var.minio_console_node_port
    }
  }
}
