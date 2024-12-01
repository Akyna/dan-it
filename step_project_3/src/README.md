## HOW TO

Terraform

```shell
cd terraform
```

```shell
terraform fmt -recursive
```

```shell
terraform init
```

```shell
terraform plan
or, if we need to run it with Terraform & Ansible -->
terraform plan -var "pvt_key=private_key_location"
```

```shell
terraform apply
or, if we need to run it with Terraform & Ansible -->
terraform apply -var "pvt_key=private_key_location"
```

```shell
terraform destroy
or, if we need to run it with Terraform & Ansible -->
terraform destroy -var "pvt_key=private_key_location"
```

Ansible

```shell
cd ansible
```
```shell
export ANSIBLE_REMOTE_USER=ubuntu
```
```shell
export ANSIBLE_PRIVATE_KEY_FILE=__path_to_sertificate__
```
```shell
export ANSIBLE_HOST_KEY_CHECKING=False
```
```shell
ansible dan_it_sp_3_master -m ping -i hosts.ini
```
```shell
ansible-lint playbook.yaml roles
```
```shell
ansible-playbook -i hosts.ini playbook.yaml
```
