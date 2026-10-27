resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop_web" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
  route_table_id = yandex_vpc_route_table.nat_rt.id
}

resource "yandex_vpc_subnet" "develop_db" {
  name           = var.subnet_db_name
  zone           = var.zone_db
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.cidr_db
  route_table_id = yandex_vpc_route_table.nat_rt.id
}


data "yandex_compute_image" "ubuntu" {
  family = var.vm_image
}

resource "yandex_compute_instance" "platform_web" {
  name        = local.vm_web_name
  platform_id = var.vm_web_platform
  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_web.id
    nat       = var.vm_web_nat
  }

  # metadata = {
  #   serial-port-enable = var.vm_web_serial_port
  #   ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  # }

  metadata = {
    serial-port-enable = var.vms_metadata.common.serial_port_enable
    ssh-keys           = "ubuntu:${file(var.vms_metadata.common.ssh_key_path)}"
  }

}

resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_db_name
  platform_id = var.vm_db_platform
  zone        = var.zone_db
  resources {
    cores         = var.vms_resources.db.cores
    memory        = var.vms_resources.db.memory
    core_fraction = var.vms_resources.db.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_db.id
    nat       = var.vm_db_nat
  }

  # metadata = {
  #   serial-port-enable = var.vm_db_serial_port
  #   ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  # }

  metadata = {
    serial-port-enable = var.vms_metadata.common.serial_port_enable
    ssh-keys           = "ubuntu:${file(var.vms_metadata.common.ssh_key_path)}"
  }

}

resource "yandex_vpc_gateway" "nat_gw" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "nat_rt" {
  name       = "nat-route-table"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gw.id
  }
}