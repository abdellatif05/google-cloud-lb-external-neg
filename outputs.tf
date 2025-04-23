output "load_balancer_url" {
  description = "The external URL of the load balancer"
  value       = "http://${google_compute_global_forwarding_rule.forwarding_rule.ip_address}"
}