## k8s

### Task

- Create deployment with python script (need to create docker image for it first and push it to your private docker hub
  registry) which returns random
  string. [Script take from GitLab](https://gitlab.com/dan-it/groups/devops_soft/-/tree/main/for_HW24?ref_type=heads)

- Create service for it

- Connect to service and perform requests to see python script response

- Make sure that service route traffic to a different pods

### HOW TO

Terraform init / plan / apply

```shell
cd src/terraform
terraform fmt -recursive
terraform init
terraform plan
terraform apply
terraform destroy
```

or

```shell
terraform fmt -recursive
terraform -chdir="./terraform" init
terraform -chdir="./terraform" plan
terraform -chdir="./terraform" apply
terraform -chdir="./terraform" destroy
```

Kubernetes

Apply configs

```shell
kubectl apply -f k8s/
```

Remove deployment

```shell
kubectl delete -f k8s/
```
