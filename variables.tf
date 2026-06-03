variable "kubeconfig_path" {
  description = "Path to the kubeconfig file used by OpenTofu to access the Kubernetes cluster."
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "Kubernetes namespace where the OCR application is deployed."
  type        = string
  default     = "default"
}

variable "filegrab_node_port" {
  description = "NodePort used to expose the FileGrab upload API."
  type        = number
  default     = 30080
}

variable "minio_api_node_port" {
  description = "NodePort used to expose the MinIO API."
  type        = number
  default     = 30002
}

variable "minio_console_node_port" {
  description = "NodePort used to expose the MinIO console."
  type        = number
  default     = 30003
}

variable "rabbitmq_management_node_port" {
  description = "NodePort used to expose the RabbitMQ management console."
  type        = number
  default     = 30672
}

variable "images" {
  description = "Container images used by the OCR microservices and infrastructure components."
  type = object({
    redis            = string
    minio            = string
    rabbitmq         = string
    zookeeper        = string
    kafka            = string
    filegrab         = string
    pdf_to_image     = string
    preprocessing    = string
    ocr              = string
    text_aggregation = string
  })

  default = {
    redis            = "redis:7-alpine"
    minio            = "minio/minio:latest"
    rabbitmq         = "rabbitmq:3.12-management-alpine"
    zookeeper        = "confluentinc/cp-zookeeper:7.5.0"
    kafka            = "confluentinc/cp-kafka:7.5.0"
    filegrab         = "filegrab:latest"
    pdf_to_image     = "pdf-to-image:latest"
    preprocessing    = "preprocessing:latest"
    ocr              = "ocr:latest"
    text_aggregation = "text-aggregation:latest"
  }
}
