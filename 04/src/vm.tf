#vm.tf - файл из демонстрации
 data "template_file" "cloudinit" {
    template = file("${path.module}/cloud-init.yml")
 
  vars = {
      username           = "ubuntu"
      ssh_public_key     = var.ssh_public_key
      packages           = jsonencode(["vim", "nginx"])
    } 
  }
module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = "develop"
  network_id      = module.vpc_module.subnet.network_id
  subnet_zones    = [module.vpc_module.subnet.zone]
  subnet_ids      = [module.vpc_module.subnet.id]
  instance_name   = "web"
  instance_count  = 1
  image_family    = "ubuntu-2004-lts"
  public_ip       = true

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }
}
