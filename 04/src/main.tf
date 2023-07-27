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

#module "vpc_module" {
#  source          = "./vpc_module"
#  vpc_name        = "test"
#  token           = var.token
#  cloude_id       = var.cloude_id
#  folder_id       = var.folder_id
#}
