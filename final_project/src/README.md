HOW TO
---

AWS configure

```shell
export AWS_PROFILE=danit
```

or

```shell
aws configure
```

and fill in all the details

Check profile

```shell
aws sts get-caller-identity
```

Docker
---
Build Docker locally and test it

```shell
docker build -t akyna/dan_it_fp:1.0.0 .
docker run --name test -p 8080:8080 -d akyna/dan_it_fp:1.0.0
```

---
Build Docker image for k8c
When it uses the Linux system add --platform=linux/amd64
Push it

```shell
docker build -t akyna/dan_it_fp:1.0.0 --platform=linux/amd64 .
docker push akyna/dan_it_fp:1.0.0
```

Steps to run:
---

- VPS
- EKS
- ARGOCD
- K8S

---

Terraform VPC - init / plan / apply

```shell
cd src/VPS
terraform fmt -recursive
terraform init
terraform plan
terraform apply
```

Go to AWS console - VPC section

Take VPC ID and subnets for `/EKS/terraform.tfvars`

```shell
vpc_id      = "..."
subnets_ids = ["subnet-private_subnet_id_1", "subnet-private_subnet_id_2", "subnet-private_subnet_id_3"]
```

---

Terraform EKS - init / plan / apply

```sh
cd src/EKS
terraform fmt -recursive
terraform init -backend-config "region=eu-central-1" -backend-config "profile=danit"
terraform plan -var="iam_profile=danit"
terraform apply -var="iam_profile=danit"
```

---

Terraform ARGOCD - init / plan / apply

Update your kubeconfig

```shell
aws eks update-kubeconfig --name __CLUSTER_NAME --region __REGION__
# For example
aws eks update-kubeconfig --name boiko --region eu-central-1
```

Check nodes

```shell
kubectl get nodes
```

```sh
cd src/ARGOCD
terraform fmt -recursive
terraform init
terraform plan
terraform apply
```

Get admin password for Argocd and login into

URL will be - `argocd.${var.cluster_name}.${var.domain_name}`

```shell
FAIL -- kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d
CORRECT - kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
```

Validate k8s manifests

```shell
cd src/K8S
kubectl apply --dry-run=client -f deployment.yaml
kubectl apply --dry-run=client -f service.yaml
kubectl apply --dry-run=client -f ingress.yaml
```

Apply our application from GutHub [repo](https://github.com/Akyna/dan-it_final_project.git)

```shell
kubectl apply -f application.yaml
```

Open Argocd URL - you should see `python-app` in list of applications

---
Make some changes in repository - this should start a new deployment

Check the progress in the Argocd admin panel

Shutdown project
---

Terraform EKS[^1]

```sh
cd src/EKS
terraform destroy -var="iam_profile=danit"
```

Terraform VPC

```shell
cd src/VPS
terraform destroy
```

[^1]: Terraform ARGOCD will be deleted against with the cluster, no need to delete it in manual mode
