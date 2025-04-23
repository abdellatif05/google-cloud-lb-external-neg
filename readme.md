# Description

This is a simple Terraform configuration for a Google Cloud global external Application Load Balancer with an external backend.

It points to https://httpbin.org

# Permissions
- Create and modify load balancer components
  - Compute Network Admin (roles/compute.networkAdmin)
- Create and modify NEGs
  - Compute Instance Admin (roles/compute.instanceAdmin)

# Google Cloud documentation
- https://cloud.google.com/load-balancing/docs/https/setup-global-ext-https-external-backend

# Attention
- In google_compute_backend_service resource:
- protocol and port_name should match the protocol of the google_compute_global_network_endpoint configuration:
  - example:
    - use protocol = "HTTPS" if the google_compute_global_network_endpoint configuration uses port 443
    - use protocol = "HTTP" if the google_compute_global_network_endpoint configuration uses port 80

# Load Balancer Scheme
- user -> google_compute_global_forwarding_rule -> google_compute_target_http_proxy -> google_compute_url_map -> google_compute_backend_service -> google_compute_global_network_endpoint -> internet (httpbin.org:443)
