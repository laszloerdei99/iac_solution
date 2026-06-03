#!/usr/bin/env bash
set -euo pipefail

echo "=== Kubernetes ellenőrzés ==="
kubectl get nodes

echo "=== OpenTofu telepítés, ha hiányzik ==="
if ! command -v tofu >/dev/null 2>&1; then
  sudo snap install opentofu --classic
fi
tofu version

echo "=== kubeconfig előkészítés OpenTofuhoz ==="
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown ubuntu:ubuntu ~/.kube/config
chmod 600 ~/.kube/config

echo "=== edu-cloud-native repo klónozás/frissítés ==="
cd ~
if [ ! -d edu-cloud-native ]; then
  git clone https://github.com/hsnlab/edu-cloud-native.git
else
  cd edu-cloud-native
  git pull
fi

echo "=== belépés az observability-iac mappába ==="
cd ~/edu-cloud-native/lab-homeworks/observability-iac

echo "=== saját IaC repo friss klónozása ==="
rm -rf iac
git clone https://github.com/laszloerdei99/iac_solution.git iac

echo "=== microservice image-ek buildelése ==="
./build-images.sh filegrab
./build-images.sh pdf-to-image
./build-images.sh preprocessing
./build-images.sh ocr
./build-images.sh text-aggregation

echo "=== OpenTofu futtatás ==="
cd iac
tofu init
tofu validate
tofu plan
tofu apply -auto-approve

echo "=== Kubernetes erőforrások ==="
kubectl get pods
kubectl get services

echo "=== Kész ==="
