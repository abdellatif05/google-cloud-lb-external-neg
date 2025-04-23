resource "google_compute_global_network_endpoint_group" "neg" {
  name                  = "neg"
  network_endpoint_type = "INTERNET_FQDN_PORT"
  default_port          = 443

  depends_on = [time_sleep.wait_for_apis]
}

resource "google_compute_global_network_endpoint" "endpoint" {
  global_network_endpoint_group = google_compute_global_network_endpoint_group.neg.name
  fqdn                          = "httpbin.org"
  port                          = 443
}

resource "google_compute_backend_service" "backend" {
  name                  = "backend"
  protocol              = "HTTPS" # should match the protocol of the google_compute_global_network_endpoint
  port_name             = "https" # should match the port of the google_compute_global_network_endpoint
  load_balancing_scheme = "EXTERNAL_MANAGED"
  timeout_sec           = 30
  enable_cdn            = false

  backend {
    group = google_compute_global_network_endpoint_group.neg.id
  }

  log_config {
    enable      = true
    sample_rate = 1.0 # Log 100% of requests (adjust between 0.0-1.0 as needed)
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "url-map"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_http_proxy" "proxy" {
  name    = "proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name                  = "forwarding-rule"
  target                = google_compute_target_http_proxy.proxy.id
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}
