output "master-external-ip" {
  value = google_compute_instance.master1.network_interface.0.access_config.0.nat_ip
}

output "slave1-external-ip" {
  value = google_compute_instance.slave1.network_interface.0.access_config.0.nat_ip
}

output "slave2-external-ip" {
  value = google_compute_instance.slave2.network_interface.0.access_config.0.nat_ip
}