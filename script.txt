https://github.com/hsnlab/edu-cloud-native/tree/main/lab-homeworks/observability-iac

https://awsacademy.instructure.com/

https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/review?templateURL=https://vitmac12-resources.s3.amazonaws.com/k3s-multinode.template&stackName=k3s-multinode



"=== 1. Kubernetes cluster ellenőrzése ==="
kubectl get nodes

"=== 2. OpenTofu telepítése, ha még nincs fent ==="
sudo snap install --classic opentofu

"=== 3. Kubeconfig előkészítése OpenTofuhoz ==="
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown ubuntu:ubuntu ~/.kube/config
chmod 600 ~/.kube/config

"=== 4. Belépés az observability-iac mappába ==="
cd ~/edu-cloud-native/lab-homeworks/observability-iac

"=== 5. Saját OpenTofu megoldás friss klónozása ==="
rm -rf iac
git clone https://github.com/laszloerdei99/iac_solution.git iac

"=== 6. Microservice image-ek buildelése ==="
./build-images.sh filegrab
./build-images.sh pdf-to-image
./build-images.sh preprocessing
./build-images.sh ocr
./build-images.sh text-aggregation

"=== 7. OpenTofu futtatása ==="
cd iac
tofu init
tofu validate
tofu plan
tofu apply -auto-approve

"=== 8. Kubernetes erőforrások ellenőrzése ==="
kubectl get pods
kubectl get services

tofu destroy