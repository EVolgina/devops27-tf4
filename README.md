# Задание 1
- Возьмите из демонстрации к лекции готовый код для создания ВМ с помощью remote модуля.
- Создайте 1 ВМ, используя данный модуль. В файле cloud-init.yml необходимо использовать переменную для ssh ключа вместо хардкода. - - Передайте ssh-ключ в функцию template_file в блоке vars ={} . Воспользуйтесь примером. Обратите внимание что ssh-authorized-keys принимает в себя список, а не строку!
- Добавьте в файл cloud-init.yml установку nginx.
- Предоставьте скриншот подключения к консоли и вывод команды sudo nginx -t.

###  Ответ
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


# Задание 3
- Выведите список ресурсов в стейте.
- Полностью удалите из стейта модуль vpc.
- Полностью удалите из стейта модуль vm.
- Импортируйте все обратно. Проверьте terraform plan - изменений быть не должно.
- Приложите список выполненных команд и скриншоты процессы.
### 




