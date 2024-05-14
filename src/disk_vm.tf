resource "yandex_compute_disk" "virtual_disk" {
  count       = 3
  name        = "virtual-disk-${count.index + 1}"
  type     = "network-hdd"
  zone        = var.default_zone
  size        = 1
  lifecycle {
    ignore_changes = [image_id,]
  }
}

resource "yandex_compute_instance" "storage" {

  name        = "netology-develop-platform-storage"
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = 5
    }
  }

  dynamic secondary_disk {
    for_each = yandex_compute_disk.virtual_disk
    content {
      disk_id     = secondary_disk.value.id
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