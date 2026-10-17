# Домашнее задание к занятию «Основы Terraform. Yandex Cloud» - Розаев А.Ю.

### Цели задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src).


### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav). 
Этот функционал понадобится к следующей лекции.

---

### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.
Убедитесь что ваша версия **Terraform** ~>1.12.0

1. Изучен проект и файл variables.tf с переменными для Yandex provider.
2. Создан сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net).

![1_2](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_1_2.png)

4. Использован текущий ssh-ключ. Открытая(public) часть ключа добавлена в переменную **vms_ssh_public_root_key** через файл terraform.tfvars.
5. Инициализирован проект, выполнен код. Исправлены допущенные ошибки:

```
│ Error: Error while requesting API to create instance: x-request-id = c1c962c5-258c-4ae0-a134-c157ef05a78f x-server-trace-id = 1bbc4b20ccb5d564:fe6ec242ddd5a660:b51d671c71827f45:1 x-client-trace-id = 72557b86-aaef-4d0c-be4d-ef44b5f09a3e rpc error: code = FailedPrecondition desc = Platform"standart-v4" not found
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
```
Исправлено значение platform_id = "standart-v4" на platform_id = "standard-v3" (Yandex Compute Cloud не предусмотрена платформа standart-v4), также исправлена ошибка в написании аргумента

```
│ Error: Error while requesting API to create instance: x-request-id = 4a3987ec-73b0-4a03-80db-264c863e0629 x-server-trace-id = dc74035fcd7bce84:0902e19d02eecaa7:80a660b7e191797a:1 x-client-trace-id = dbee7271-6a6f-4b9a-bdc9-59e71639ce2b rpc error: code = InvalidArgument desc = the specified core fraction is not available on platform "standard-v3"; allowed core fractions: 20, 50, 100
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
```
Исправлено значение core_fraction = 5 на core_fraction = 20 (значение core_fraction = 5 платформой не поддерживается)

```
│ Error: Error while requesting API to create instance: x-request-id = 49fefead-d58e-4fc5-b8a6-d6c4561bb6f2 x-server-trace-id = 8b28e85dedf6b23e:44a00627c6ebd330:7bc5bde0d3e05b8b:1 x-client-trace-id = b54a4004-e1dc-4a36-9797-61d1d7747fef rpc error: code = InvalidArgument desc = the specified number of cores is not available on platform "standard-v3"; allowed core number: 2, 4
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
```
Исправлено значение cores = 1 на cores = 2 (значение cores = 1 платформой не поддерживается)

Создана ВМ, в консоли облачной ВМ выполнена команда ``` curl ifconfig.me```.

![1_5_1](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_1_5_1.png)

![1_5_2](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_1_5_2.png)


6. Параметры ```preemptible = true``` и ```core_fraction = 20``` существенно сокращают стоимость использования ВМ.

---

### Задание 2

1. Произведена замена всех хардкод-**значений** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавлен префикс **vm_web_**.
- var.vm_image
- var.vm_web_name
- var.vm_web_platform
- var.vm_web_cores
- var.vm_web_memory
- var.vm_web_core_fraction
- var.vm_web_preemptible
- var.vm_web_nat
- var.vm_web_serial_port

2. Новые переменные объявлены в файле variables.tf, с указанием соответствующих **type** переменной, их значений в поле **default** из main.tf и **description** 
3. Terraform plan без изменений 

![2_3](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_2_3.png)

---

### Задание 3

1. В корне проекта создан файл 'vms_platform.tf' . В него перенесены все переменные первой ВМ.
2. Скопирован блок ресурса и создана с его помощью вторая ВМ в файле main.tf: **"netology-develop-platform-db"** , ```cores  = 2, memory = 2, core_fraction = 20```. Объявлены её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').  ВМ размещена в зоне "ru-central1-b"
3. Применены изменения.

![3_3](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_3_3.png)

---

### Задание 4

1. В файле outputs.tf объявлен **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ.
2. Применены изменения.

Вывод значений ip-адресов команды ```terraform output```:

![4](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_4.png)

---

### Задание 5

1. В файле locals.tf описаны в **одном** local-блоке имя каждой ВМ, с использованием интерполяции ${..} с несколькими переменными.
2. Переменные заменены внутри ресурса ВМ на созданные local-переменные.
3. Применены изменения.

![5](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_5.png)

---

### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, произведено их объединение в единую map-переменную **vms_resources** и внутри неё объеденены конфиги обеих ВМ в виде вложенного map(object).
3. Создана и использована отдельная map(object) переменная для блока metadata, общая для всех ВМ.
5. Закоментированы все, более не используемые переменные проекта.
6. Выполнен terraform apply. Изменений нет.

![6](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_6.png)

------

## Дополнительное задание (со звёздочкой*)

------
### Задание 7*

Изучено содержимое файла console.tf. Запущена terraform console, выполнены следующие задания: 

1. Напишите, какой командой можно отобразить второй элемент списка test_list.

Для отображения **второго** элемента списка test_list, необходимо найти индекс 1 (индексы начинаются с 0)
```
local.test_list[1]
```
Ответ: "staging"

![7_1](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_7_1.png)

2. Найдите длину списка test_list с помощью функции length(<имя переменной>).

Для определения длины списка test_list необходимо использывать функцию:
```
length(local.test_list)
```
Ответ: 3

![7_2](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_7_2.png)

3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.

Получить значение по ключу из map-структуры можно через точку
```
local.test_map.admin
```
Ответ: "John"

![7_3](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_7_3.png)

4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

Для вывода данной фразы необходимо использовать вырежение
```
"${local.test_map.admin} is admin for ${local.test_list[2]} server based on OS ${local.servers.production.image} with ${local.servers.production.cpu} vcpu, ${local.servers.production.ram} ram and ${length(local.servers.production.disks)} virtual disks"
```
Ответ: "John is admin for production server based on OS ubuntu-20-04 with 10 vcpu, 40 ram and 4 virtual disks"

![7_4](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_7_4.png)

------

### Задание 8*
1. Напишите и проверьте переменную test и полное описание ее type в соответствии со значением из terraform.tfvars:
```
test = [
  {
    "dev1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
      "10.0.1.7",
    ]
  },
  {
    "dev2" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
      "10.0.2.29",
    ]
  },
  {
    "prod1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
      "10.0.1.30",
    ]
  },
]
```
Для данного значения переменной необходимо использовать список карт, где значениями являются списки строк.
```
variable "test" {
  description = "List of maps"
  type        = list(map(list(string)))
}
```

![8_1](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_8_1.png)


2. Напишите выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117" из этой переменной.

Чтобы получить эту строку, нужно последовательно обратиться к элементам переменной по их индексам и ключам
```
var.test[0]["dev1"][0]
```

![8_2](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_8_2.png)

------

### Задание 9*

Используя инструкцию https://cloud.yandex.ru/ru/docs/vpc/operations/create-nat-gateway#tf_1, настроен для ВМ nat_gateway. 
Для проверки убран внешний IP адрес (nat=false) у ВМ и проверен доступ в интернет (ping 8.8.8.8) с ВМ, подключившись к ним через serial console.
Для подключения предварительно через ssh изменен пароль пользователя: ```sudo passwd ubuntu```

![9_1](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_9_1.png)

![9_2](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_9_2.png)

![9_3](https://github.com/expgt/net-fops-hw-15-2/blob/main/15_2_9_3.png)

