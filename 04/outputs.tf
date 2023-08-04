output "subnet" {
  value = module.vpc_module.yandex_vpc_subnet.subnet
}

output "vpc_name" {
  value = module.vpc_module.yandex_vpc_network.vpc.name
}

output "network_id" {
  value = module.vpc_module.yandex_vpc_network.vpc.id
}

