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
