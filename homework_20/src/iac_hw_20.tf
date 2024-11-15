module "iac_hw_20" {
  source             = "./iac_hw_20"
  instance_type      = var.instance_type
  region             = var.region
  vpc_id             = var.vpc_id
  subnet_id          = var.subnet_id
  list_of_open_ports = var.list_of_open_ports
}
