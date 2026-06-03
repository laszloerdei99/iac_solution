resource "kubernetes_deployment_v1" "zookeeper" {
  metadata {
    name      = "zookeeper"
    namespace = var.namespace

    labels = {
      app = "zookeeper"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "zookeeper"
      }
    }

    template {
      metadata {
        labels = {
          app = "zookeeper"
        }
      }

      spec {
        container {
          name  = "zookeeper"
          image = var.images.zookeeper

          port {
            container_port = 2181
          }

          env {
            name  = "ZOOKEEPER_CLIENT_PORT"
            value = "2181"
          }

          env {
            name  = "ZOOKEEPER_TICK_TIME"
            value = "2000"
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

resource "kubernetes_service_v1" "zookeeper" {
  metadata {
    name      = "zookeeper"
    namespace = var.namespace
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = "zookeeper"
    }

    port {
      port        = 2181
      target_port = 2181
    }
  }
}

resource "kubernetes_deployment_v1" "kafka" {
  metadata {
    name      = "kafka"
    namespace = var.namespace

    labels = {
      app = "kafka"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "kafka"
      }
    }

    template {
      metadata {
        labels = {
          app = "kafka"
        }
      }

      spec {
        container {
          name    = "kafka"
          image   = var.images.kafka
          command = ["bash", "-c", "unset KAFKA_PORT && /etc/confluent/docker/run"]

          port {
            container_port = 9092
            name           = "kafka"
          }

          env {
            name  = "KAFKA_BROKER_ID"
            value = "1"
          }

          env {
            name  = "KAFKA_ZOOKEEPER_CONNECT"
            value = "zookeeper:2181"
          }

          env {
            name  = "KAFKA_ADVERTISED_LISTENERS"
            value = "PLAINTEXT://kafka:9092"
          }

          env {
            name  = "KAFKA_LISTENERS"
            value = "PLAINTEXT://0.0.0.0:9092"
          }

          env {
            name  = "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR"
            value = "1"
          }

          env {
            name  = "KAFKA_AUTO_CREATE_TOPICS_ENABLE"
            value = "true"
          }

          resources {
            requests = {
              memory = "512Mi"
              cpu    = "150m"
            }

            limits = {
              memory = "1Gi"
              cpu    = "400m"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service_v1.zookeeper
  ]
}

resource "kubernetes_service_v1" "kafka" {
  metadata {
    name      = "kafka"
    namespace = var.namespace
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = "kafka"
    }

    port {
      name        = "kafka"
      port        = 9092
      target_port = 9092
    }
  }
}
