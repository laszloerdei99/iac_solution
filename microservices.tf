resource "kubernetes_deployment_v1" "filegrab" {
  metadata {
    name      = "filegrab"
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "filegrab"
      }
    }

    template {
      metadata {
        labels = {
          app = "filegrab"
        }
      }

      spec {
        container {
          name              = "filegrab"
          image             = var.images.filegrab
          image_pull_policy = "IfNotPresent"

          port {
            container_port = 5000
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map_v1.ocr_services_config.metadata[0].name
            }
          }

          resources {
            requests = {
              memory = "64Mi"
              cpu    = "20m"
            }

            limits = {
              memory = "128Mi"
              cpu    = "50m"
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 5000
            }

            initial_delay_seconds = 10
            period_seconds        = 30
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 5000
            }

            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_config_map_v1.ocr_services_config,
    kubernetes_service_v1.redis,
    kubernetes_service_v1.minio
  ]
}

resource "kubernetes_service_v1" "filegrab" {
  metadata {
    name      = "filegrab"
    namespace = var.namespace
  }

  spec {
    type = "NodePort"

    selector = {
      app = "filegrab"
    }

    port {
      port        = 5000
      target_port = 5000
      node_port   = var.filegrab_node_port
    }
  }
}

resource "kubernetes_deployment_v1" "pdf_to_image" {
  metadata {
    name      = "pdf-to-image"
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "pdf-to-image"
      }
    }

    template {
      metadata {
        labels = {
          app = "pdf-to-image"
        }
      }

      spec {
        container {
          name              = "pdf-to-image"
          image             = var.images.pdf_to_image
          image_pull_policy = "IfNotPresent"

          env_from {
            config_map_ref {
              name = kubernetes_config_map_v1.ocr_services_config.metadata[0].name
            }
          }

          resources {
            requests = {
              memory = "512Mi"
              cpu    = "300m"
            }

            limits = {
              memory = "1Gi"
              cpu    = "500m"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_config_map_v1.ocr_services_config,
    kubernetes_service_v1.redis,
    kubernetes_service_v1.minio
  ]
}

resource "kubernetes_deployment_v1" "preprocessing" {
  metadata {
    name      = "preprocessing"
    namespace = var.namespace

    labels = {
      app = "preprocessing"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "preprocessing"
      }
    }

    template {
      metadata {
        labels = {
          app = "preprocessing"
        }
      }

      spec {
        container {
          name              = "preprocessing"
          image             = var.images.preprocessing
          image_pull_policy = "IfNotPresent"

          env_from {
            config_map_ref {
              name = kubernetes_config_map_v1.ocr_services_config.metadata[0].name
            }
          }

          resources {
            requests = {
              memory = "256Mi"
              cpu    = "150m"
            }

            limits = {
              memory = "512Mi"
              cpu    = "300m"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_config_map_v1.ocr_services_config,
    kubernetes_service_v1.redis,
    kubernetes_service_v1.minio,
    kubernetes_service_v1.rabbitmq
  ]
}

resource "kubernetes_deployment_v1" "ocr" {
  metadata {
    name      = "ocr"
    namespace = var.namespace

    labels = {
      app = "ocr"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "ocr"
      }
    }

    template {
      metadata {
        labels = {
          app = "ocr"
        }
      }

      spec {
        container {
          name              = "ocr"
          image             = var.images.ocr
          image_pull_policy = "IfNotPresent"

          env_from {
            config_map_ref {
              name = kubernetes_config_map_v1.ocr_services_config.metadata[0].name
            }
          }

          resources {
            requests = {
              memory = "256Mi"
              cpu    = "150m"
            }

            limits = {
              memory = "512Mi"
              cpu    = "300m"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_config_map_v1.ocr_services_config,
    kubernetes_service_v1.minio,
    kubernetes_service_v1.rabbitmq,
    kubernetes_service_v1.kafka
  ]
}

resource "kubernetes_deployment_v1" "text_aggregation" {
  metadata {
    name      = "text-aggregation"
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "text-aggregation"
      }
    }

    template {
      metadata {
        labels = {
          app = "text-aggregation"
        }
      }

      spec {
        container {
          name              = "text-aggregation"
          image             = var.images.text_aggregation
          image_pull_policy = "IfNotPresent"

          env_from {
            config_map_ref {
              name = kubernetes_config_map_v1.ocr_services_config.metadata[0].name
            }
          }

          resources {
            requests = {
              memory = "128Mi"
              cpu    = "50m"
            }

            limits = {
              memory = "256Mi"
              cpu    = "100m"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_config_map_v1.ocr_services_config,
    kubernetes_service_v1.minio,
    kubernetes_service_v1.redis,
    kubernetes_service_v1.kafka
  ]
}
