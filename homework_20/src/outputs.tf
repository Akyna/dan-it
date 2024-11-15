# Output from Child Module Outputs
output "instance_ip" {
  description = "Instance ip. Parent level"
  value       = module.iac_hw_20.instance_ip
}
