output "lb_address" {
  value       = local.lb_address
  description = "Load balancer address."
}

output "app_link" {
  value       = local.fqdn
  description = "Application fully qualified domain name."
}
