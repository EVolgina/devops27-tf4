#./demonstration1/main.tf
module "vpc_module" {
  source          = "./vpc_module"
  vpc_name        = "test"
  token           = var.token
  cloude_id       = var.cloude_id
  folder_id       = var.folder_id
}


#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

#создаем подсеть
resource "yandex_vpc_subnet" "develop" {
  name           = "develop-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = "develop"
  network_id      = yandex_vpc_network.develop.id
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [ yandex_vpc_subnet.develop.id ]
  instance_name   = "web"
  instance_count  = 2
  image_family    = "ubuntu-2004-lts"
  public_ip       = true
  
  metadata = {
      user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
      serial-port-enable = 1
  }
  metadata = {
    serial-port-enable = var.vms_ssh_root_key.serial-port-enable
    ssh-keys           = var.vms_ssh_root_key.ssh-keys
  }
}
data "template_file" "cloudinit" {
  template = file("${path.module}/cloud-init.yml")

  vars = {
    username           = "ubuntu"
    ssh_public_key     = var.ssh_public_key
    packages           = jsonencode(["vim", "nginx"])
  }
}

  
