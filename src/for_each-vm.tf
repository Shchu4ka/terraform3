
resource "yandex_compute_instance" "db" {
  for_each = {
    0 = "main"
    1 = "replica"

}

  name        = "netology-develop-platform-db-${each.value}"
  platform_id = "standard-v1"

  resources {
    cores  = var.each_vm[each.key].cpu
    memory = var.each_vm[each.key].ram
}

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = var.each_vm[each.key].disk_volume
    }
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = local.ssh
  }

  scheduling_policy {
    preemptible = true
}

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  allow_stopping_for_update = true
}
