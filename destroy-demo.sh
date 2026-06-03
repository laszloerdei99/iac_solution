#!/usr/bin/env bash
set -euo pipefail

cd ~/edu-cloud-native/lab-homeworks/observability-iac/iac
tofu destroy -auto-approve

kubectl get pods
kubectl get services
