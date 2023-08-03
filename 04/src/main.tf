#./04/src/main.tf
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

module "vpc_module" {
  source          = "./vpc_module"
  vpc_name        = "test2"
  default_zone    = "ru-central1-a"
  v4_cidr_blocks  = ["10.0.1.0/24"]
}
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
#./demonstration1/main.tf
# terraform {
#  required_providers {
#    yandex = {
#      source = "yandex-cloud/yandex"
#    }
#  }
#  required_version = ">=0.13"
#}

#provider "yandex" {
#  token     = var.token
#  cloud_id  = var.cloud_id
#  folder_id = var.folder_id
#  zone      = var.default_zone
#}

#создаем облачную сеть
#resource "yandex_vpc_network" "develop" {
#  name = var.vpc_name
#}

#создаем подсеть
#resource "yandex_vpc_subnet" "develop" {
#name           = "develop-ru-central1-a"
#zone           = "ru-central1-a"
#network_id     = yandex_vpc_network.develop.id
#v4_cidr_blocks = ["10.0.1.0/24"]
#}

module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = "develop"
  network_id      = module.vpc.yandex_vpc_subnet.subnet_info.network_id
  subnet_zones    = [module.vpc.yandex_vpc_subnet.subnet_info.zone]
  subnet_ids      = [module.vpc.yandex_vpc_subnet.subnet_info.id]
  instance_name   = "web"
  instance_count  = 1
  image_family    = "ubuntu-2004-lts"
  public_ip       = true
  
  metadata = {
      user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
      serial-port-enable = 1
  }
}
  data "template_file" "cloudinit" {
  template = file("${path.module}/cloud-init.yml")

  vars = {
    username           = "ubuntu"
    ssh_public_key     = var.ssh_public_key
