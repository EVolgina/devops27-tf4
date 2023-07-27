# vpc_module/main.tf

variable "vpc_name" {
  type        = string
  description = "Name of the VPC network"
}

variable "zone" {
  type        = string
  description = "Zone for the VPC subnet, e.g., ru-central1-a"
}

variable "v4_cidr_blocks" {
  type        = list(string)
  description = "List of IPv4 CIDR blocks for the subnet"
}

resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "subnet" {
  name           = var.vpc_name
  zone           = var.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = var.v4_cidr_blocks
}
