#!/bin/sh

set_gpio()
{
    if [ ! -d "/sys/class/gpio/GPIO$1" ]; then
        echo $1 > /sys/class/gpio/export
        echo out > /sys/class/gpio/GPIO$1/direction
    fi

    echo $2 > /sys/class/gpio/GPIO$1/value
}

insmod vmm.ko mmz=anonymous,0,0xA2800000,24M anony=1

#reset sensor
set_gpio 13 0

/bin/echo /sbin/mdev > /proc/sys/kernel/hotplug
mkdir -p /lib/firmware

tar -zxvf /home/base/ko/rtthread_arc_FH8626V100.tar.gz -C /lib/firmware

insmod xbus_rpc.ko  fn=/lib/firmware/rtthread_arc_FH8626V100.bin fa=0xbff80000

rm -f /lib/firmware/rtthread_arc_FH8626V100_human_detect.bin

#reset sensor
set_gpio 13 1

tar -zxvf /home/base/ko/model_human_86185422.tar.gz -C /tmp
tar -zxvf /home/base/ko/model_human_86185770.tar.gz -C /tmp

insmod media_process.ko
insmod isp.ko
insmod enc.ko
insmod jpeg.ko
insmod bgm.ko
#insmod vbus_ac.ko
