#!/system/bin/sh
#
# Copyright (C) 2017 Michele Beccalossi <beccalossi.michele@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

mount -o rw,remount /
mount -o rw,remount /system

# init.d support
if [ ! -e /system/etc/init.d ]; then
	mkdir /system/etc/init.d
	chown -R root.root /system/etc/init.d
	chmod -R 755 /system/etc/init.d
fi

# start init.d
for file in /system/etc/init.d/*; do
	sh $file >/dev/null
done

# Stock Settings borrowed from my dude djb77
echo interactive > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 2288000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
echo 208000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
echo 1586000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 130000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 650 > /sys/devices/14ac0000.mali/max_clock
echo 260 > /sys/devices/14ac0000.mali/min_clock
echo westwood > /proc/sys/net/ipv4/tcp_congestion_control

mount -o ro,remount /
mount -o ro,remount /system
