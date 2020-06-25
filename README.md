# rnr-4x4

#### Необходимые пакеты для сборки
* make
* cmake
* git

## Сборка
1. Склонировать репозиторий https://github.com/uboborov/rnr-4x4.git
2. Зайти в каталог склонированного репозитория to rnr-4x4
3. Запустить скрипт **./buildall.sh script**
4. По завершению сборки образ ядра и файловой системы будут находиться в каталоге **rnr-4x4/output**

В процессе сборки могут возникнуть ошибки. Чаще всего они возникают из-за отсутствия необходимых для сборки пакетов и отображаются в консоли красным цветом. При возникновении ошибок сборки скрипт останавливается до их устранения.

## Установка образа
1. Записать на SD карту образ Lubuntu (https://drive.google.com/open?id=0B2ZvWXG-omrAMzlORzMzMjBVLU0)
2. На раздел FAT SD карты записать ядро **rnr-4x4/output/uImage** с заменой файла
3. Распаковать архив **rnr-4x4/output/rootfs.tar** в корень раздела EXT4 SD карты
4. Настроить параметры видео (можно не настраивать и все оставить поумолчанию)
5. Запустить просмотр RTSP потока (**mpv rtsp://ВАШ_IP:554/live.cam**)

## Настройка.
  Сервис использует систему хранения конфигурации UCI от OpenWrt (https://openwrt.org/docs/guide-user/base-system/uci)
  Можно руками правть файл конфигурации /etc/config/system, а можно и средствами uci из консоли:
  
  uci show - просмотр всего конфига
  uci set - установка значения переменной
  uci commit - запись изменений в файл
  
  ##### пример.
  Просмотр:
  `uci show`
  
      system.rtsp=rtsp
      system.rtsp.proto='udp'
      system.rtsp.device='/dev/video0'
      system.rtsp.format='YUYV'
      system.rtsp.port='554'
      system.rtsp.resolution='1280x720'
      system.rtsp.framerate='25'
      system.rtsp.channel='live.cam2'
    
system.rtsp.device - камера UVC
system.rtsp.format - формат кадра от камеры
system.rtsp.port - rtsp порт
system.rtsp.channel - rtsp uri
system.rtsp.resolution - разрешение камеры
      
Установка:
  `uci set system.rtsp.device=/dev/video1`
  
Запись в файл конфигурации:
  `uci commit`
  
После настройки во время работы сервиса необходимо перечитать новый конфиг и перезапустить приложения:
`killall -15 supervisor`

## PS:
**Отсутствие RTSP потока возможно по причине неподключенной камеры, неправильно заданного видеоустройства(/dev/video0/1/2...), формата(YUYV), порт(554) может быть 
занят вашими приложениями, неправильного URI(rtsp://ВАШ_IP:554/live.cam).**

Если вы всё проверили и уверенны, что все правильно, но RTSP потока нет, то пришлите, пожалуйста, вывод команд: 
* `uci show`
* `lsmod`
* `ps -ax`
* `ls /dev`
