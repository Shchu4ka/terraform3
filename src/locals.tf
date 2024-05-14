locals {
  ssh = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  storage_fqdn = yandex_compute_instance.storage.fqdn
  storage_name = yandex_compute_instance.storage.name
  storage_ip = yandex_compute_instance.storage.network_interface[0].nat_ip_address
}