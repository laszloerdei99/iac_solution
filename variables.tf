variable "kubeconfig_path" {
  description = "Path to kubeconfig."
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "Kubernetes namespace."
  type        = string
  default     = "default"
}

variable "filegrab_node_port" {
  description = "NodePort for FileGrab upload API."
  type        = number
  default     = 30080
}
