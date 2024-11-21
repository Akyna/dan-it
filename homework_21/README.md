## AWS Terraform and Ansible Exercise

### Task

- Create Terraform code to run two EC2 instances
- Terraform must automatically prepare an Ansible inventory file

### Write an Ansible playbook that:

- Installs Docker
- Installs Docker Compose
- Pulls the Nginx image
- Runs Nginx with Docker Compose
- Apply the Ansible playbook manually. It should deploy everything on both EC2 instances

### HOW TO

Terraform 

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
terraform plan
```

```shell
terraform apply
```

```shell
terraform destroy
```

Ansible
```shell
cd ansible
```

```shell
ansible-inventory -i __file_name__ --list
-->
ansible-inventory -i hosts.ini --list
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
ansible __inventory_group_name__ -m ping -i __file_name__
-->
ansible hw_21_servers -m ping -i hosts.ini
```
```shell
ansible-lint __playbook_file_name__ __folder_name_with_roless__
-->
ansible-lint playbook.yaml roles
```
```shell
ansible-playbook -i __inventory_file__ __playbook_file_name__
-->
ansible-playbook -i hosts.ini playbook.yaml
```
