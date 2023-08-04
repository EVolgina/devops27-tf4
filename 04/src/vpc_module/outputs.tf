output "subnet" {
  value = yandex_vpc_subnet.subnet
}

output "vpc_name" {
  value = yandex_vpc_network.vpc.name
}

output "network_id" {
  value = yandex_vpc_network.vpc.id
}


