## AWS Terraform Module Exercise

### AWS Terraform Module Exercise

### Task

Create a Terraform module that takes the following input values:

- vpc_id
- list_of_open_ports

Then creates in the `eu-north-1` region:

- A security group that allows access from anywhere to ports from input in the specified VPC.
- A public EC2 instance in the specified VPC with an installed default Nginx server or Nginx running in a container

Then outputs:

- IP of the created instance

Use `http://IP` to confirm that Nginx is running

### Backend

Configure S3 backend for your project

- Use the terraform-state-danit-devops-2 bucket in the `eu-central-1` region
- Configure a unique path for your state by using your login name
- Ensure that the file is created in the bucket and gets updated when you change the infrastructure

### HOW TO

```shell
cd src
```

```shell
terraform fmt -recursive
```

```shell
terraform init
```

```shell
terraform plan -var-file="iac_hw_20.tfvars"
```

```shell
terraform apply -var-file="iac_hw_20.tfvars"
```

```shell
terraform destroy -var-file="iac_hw_20.tfvars"
```
