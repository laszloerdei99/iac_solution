resource "kubernetes_config_map_v1" "ocr_services_config" {
  metadata {
    name      = "ocr-services-config"
    namespace = var.namespace
  }

  data = {
    REDIS_HOST = "redis"
    REDIS_PORT = "6379"

    MINIO_HOST       = "minio:9000"
    MINIO_ACCESS_KEY = "minioadmin"
    MINIO_SECRET_KEY = "minioadmin"
    MINIO_BUCKET     = "ocr-processing"

    RABBITMQ_HOST     = "rabbitmq"
    RABBITMQ_USER     = "guest"
    RABBITMQ_PASSWORD = "guest"

    KAFKA_BOOTSTRAP_SERVERS = "kafka:9092"
    KAFKA_TOPIC             = "ocr_results"
    KAFKA_GROUP_ID          = "text-aggregators"
  }
}
