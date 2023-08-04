# Задание 1
- Возьмите из демонстрации к лекции готовый код для создания ВМ с помощью remote модуля.
- Создайте 1 ВМ, используя данный модуль. В файле cloud-init.yml необходимо использовать переменную для ssh ключа вместо хардкода. - - Передайте ssh-ключ в функцию template_file в блоке vars ={} . Воспользуйтесь примером. Обратите внимание что ssh-authorized-keys принимает в себя список, а не строку!
- Добавьте в файл cloud-init.yml установку nginx.
- Предоставьте скриншот подключения к консоли и вывод команды sudo nginx -t.

###  Ответ
![yovm]()
```
devops@WORKBOOK:~/ter-homeworks/04/src$ ssh ubuntu@158.160.61.41
hostkeys_find_by_key_hostfile: hostkeys_foreach failed for /etc/ssh/ssh_known_hosts: Permission denied
The authenticity of host '158.160.61.41 (158.160.61.41)' can't be established.
ED25519 key fingerprint is SHA256:KpauINp/qnlwuLOcG3f7G4CzOS/caX9PxcRmvFf8Jtc.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '158.160.61.41' (ED25519) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-153-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.
Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
ubuntu@develop-web-0:~$ sudo nginx -t
sudo: nginx: command not found
ubuntu@develop-web-0:~$ sudo nginx -v
nginx version: nginx/1.18.0 (Ubuntu)
```
# Задание 2
- Напишите локальный модуль vpc, который будет создавать 2 ресурса: одну сеть и одну подсеть в зоне, объявленной при вызове модуля. например: ru-central1-a.
- Вы должны передать в модуль переменные с названием сети, zone и v4_cidr_blocks .
- Модуль должен возвращать в виде output информацию о yandex_vpc_subnet
- Замените ресурсы yandex_vpc_network и yandex_vpc_subnet, созданным модулем. Не забудьте передать необходимые параметры сети из модуля vpc в модуль с виртуальной машиной.
- Откройте terraform console и предоставьте скриншот содержимого модуля. Пример: > module.vpc_dev
- Сгенерируйте документацию к модулю с помощью terraform-docs.
- Пример вызова:
```
module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  zone = "ru-central1-a"
  cidr = "10.0.1.0/24"
}
```
### ответ: создала папку vpc_module в нем файл main.tf. Создала VPC.MD и outputs.tf
```
sudo terraform-docs markdown table "/home/devops/ter-homeworks/04/src" --output-
file "VPC.md"

```

![vpc](https://github.com/EVolgina/devops27-tf4/blob/main/vpc.PNG)


# Задание 3
- Выведите список ресурсов в стейте.
- Полностью удалите из стейта модуль vpc.
- Полностью удалите из стейта модуль vm.
- Импортируйте все обратно. Проверьте terraform plan - изменений быть не должно.
- Приложите список выполненных команд и скриншоты процессы.
### Ответ:
```
devops@WORKBOOK:~/ter-homeworks/04/src$ terraform state list
yandex_vpc_network.develop
yandex_vpc_subnet.develop
module.test-vm.data.yandex_compute_image.my_image
module.test-vm.yandex_compute_instance.vm[0]
devops@WORKBOOK:~/ter-homeworks/04/src$ terraform state show module.vpc_module.yandex_vpc_network.vpc
# module.vpc_module.yandex_vpc_network.vpc:
resource "yandex_vpc_network" "vpc" {
    created_at = "2023-07-29T13:01:59Z"
    folder_id  = "b1gpoeqn2q7if0pboa4u"
    id         = "enpe3coakvgvu82oj96c"
    labels     = {}
    name       = "test2"
    subnet_ids = []
}
devops@WORKBOOK:~/ter-homeworks/04/src$ terraform state show module.vpc_module.yandex_vpc_subnet.subnet
# module.vpc_module.yandex_vpc_subnet.subnet:
resource "yandex_vpc_subnet" "subnet" {
    created_at     = "2023-07-29T13:02:03Z"
    folder_id      = "b1gpoeqn2q7if0pboa4u"
    id             = "e9bsaoqpveg3eednp84q"
    labels         = {}
    name           = "test2"
    network_id     = "enpe3coakvgvu82oj96c"
    v4_cidr_blocks = [
        "10.0.1.0/24",
    ]
    v6_cidr_blocks = []
    zone           = "ru-central1-a"
}
```
```
devops@WORKBOOK:~/ter-homeworks/04/src$ terraform state rm module.vpc_module
Removed module.vpc_module.yandex_vpc_network.vpc
Removed module.vpc_module.yandex_vpc_subnet.subnet
Successfully removed 2 resource instance(s).
devops@WORKBOOK:~/ter-homeworks/04/src$ terraform import module.vpc_module.yandex_vpc_network.vpc enpe3coakvgvu82oj96c
var.vpc_name
  VPC network&subnet name

  Enter a value: test2

module.vpc_module.yandex_vpc_network.vpc: Importing from ID "enpe3coakvgvu82oj96c"...
module.vpc_module.yandex_vpc_network.vpc: Import prepared!
  Prepared yandex_vpc_network for import
module.vpc_module.yandex_vpc_network.vpc: Refreshing state... [id=enpe3coakvgvu82oj96c]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```
```
Successfully removed 1 resource instance(s).
devops@WORKBOOK:~/ter-homeworks/04/src/demonstration1$ terraform state rm module.test-vm.yandex_compute_instance.vm[0]
Removed module.test-vm.yandex_compute_instance.vm[0]
Successfully removed 1 resource instance(s).
devops@WORKBOOK:~/ter-homeworks/04/src/demonstration1$ terraform import module.test-vm.yandex_compute_instance.vm[1] fhm1od3qsnha8hhcmgfn
devops@WORKBOOK:~/ter-homeworks/04/src/demonstration1$ terraform import module.test-vm.yandex_compute_instance.vm[0] fhmspv74bpi33rrpqpre

```
```
terraform plan
Plan: 5 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if
you run "terraform apply" now.
```

