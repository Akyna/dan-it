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

Kubernetes

Before all, we must have a created Volume

```shell
# Find the availability zone of your worker nodes
INSTANCE_ID=$(kubectl get nodes -o jsonpath='{.items[0].spec.providerID}' | cut -d'/' -f5)
AZ=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].Placement.AvailabilityZone' --output text)

# Create EBS volume in the correct AZ
aws ec2 create-volume \
    --volume-type gp3 \
    --size 10 \
    --availability-zone $AZ \
    --encrypted
```

Apply configs

```shell
kubectl apply -f k8s/mysql.yaml
```

```shell
kubectl apply -f k8s/flask.yaml
```

Remove deployment

```shell
kubectl delete -f k8s/
```

---

Build Docker image for k8c, in case, when it uses the Linux system

```shell
docker build -t akyna/sp_4:1.0.1 --platform=linux/amd64 .
docker push akyna/sp_4:1.0.1
```

---

Build Docker and run test

```shell
docker build --target test .
```

---


Q: Is there a way to list what CSI drivers are installed in Kubernetes cluster?

```shell
kubectl get csidriver
```

or

```shell
kubectl get pods -n kube-system
```

and found `ebs-csi-controller` and `ebs-csi-node`

---

Check Supported Addon Versions
AWS EKS add-ons require specific versions based on the Kubernetes version of your EKS cluster. To find the correct
version:

```shell
aws eks describe-addon-versions --addon-name aws-ebs-csi-driver
```

---

See pod histore

```shell
kubectl rollout history deployment/flask-sp-4 -n boiko-app
```
