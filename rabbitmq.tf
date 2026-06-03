resource "kubernetes_deployment_v1" "rabbitmq" {
  metadata {
    name      = "rabbitmq"
    namespace = var.namespace

    labels = {
      app = "rabbitmq"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "rabbitmq"
      }
    }

    template {
      metadata {
        labels = {
          app = "rabbitmq"
        }
      }

      spec {
        container {
          name  = "rabbitmq"
          image = var.images.rabbitmq

          port {
            container_port = 5672
            name           = "amqp"
          }

          port {
            container_port = 15672
            name           = "management"
          }

          env {
            name  = "RABBITMQ_DEFAULT_USER"
            value = "guest"
          }

          env {
            name  = "RABBITMQ_DEFAULT_PASS"
            value = "guest"
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

resource "kubernetes_service_v1" "rabbitmq" {
  metadata {
    name      = "rabbitmq"
    namespace = var.namespace
  }

  spec {
    type = "NodePort"

    selector = {
      app = "rabbitmq"
    }

    port {
      name        = "amqp"
      port        = 5672
      target_port = 5672
    }

    port {
      name        = "management"
      port        = 15672
      target_port = 15672
      node_port   = var.rabbitmq_management_node_port
    }
  }
}
