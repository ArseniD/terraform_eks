output "lb_address" {
  value       = module.app.lb_address
  description = "Load balancer address."
}

output "app_link" {
  value       = module.app.app_link
  description = "Application fully qualified domain name."
}
