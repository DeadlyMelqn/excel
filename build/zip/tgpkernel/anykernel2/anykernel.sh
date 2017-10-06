# -------------------------------
# TGPKERNEL AROMA INSTALLER v2.14
# anykernel2 portion
#
# Anykernel2 created by #osm0sis
# S8Port/NFE mods by @kylothow
# Kernel paths from @Morogoku
# Everything else done by @djb77
#
# DO NOT USE ANY PORTION OF THIS
# CODE WITHOUT MY PERMISSION!!
# -------------------------------

## AnyKernel setup
# Begin Properties
properties() {
kernel.string=
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=herolte
device.name2=hero2lte
device.name3=
device.name4=
device.name5=
} # end properties

# Extra 0's needed for CPU Freqs
ZEROS=000

# Shell Variables
block=/dev/block/platform/155a0000.ufs/by-name/BOOT;
is_slot_device=0;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;

## AnyKernel install
ui_print "- Extracing Boot Image";
dump_boot;

# Ramdisk changes - Modded / New Files
ui_print "- Adding TGPKernel Mods";
replace_file sbin/resetprop 755 s7/sbin/resetprop;
replace_file sbin/initd.sh 755 s7/sbin/initd.sh;
replace_file sbin/kernelinit.sh 755 s7/sbin/kernelinit.sh;
replace_file sbin/wakelock.sh 755 s7/sbin/wakelock.sh;
replace_file init 755 s7/init;
replace_file fstab.samsungexynos8890 644 s7/fstab.samsungexynos8890;
replace_file fstab.samsungexynos8890.fwup 644 s7/fstab.samsungexynos8890.fwup;
replace_file init.services.rc 755 s7/init.services.rc;

# Ramdisk changes - default.prop
replace_string default.prop "ro.secure=0" "ro.secure=1" "ro.secure=0";
replace_string default.prop "ro.debuggable=0" "ro.debuggable=1" "ro.debuggable=0";
replace_string default.prop "persist.sys.usb.config=mtp,adb" "persist.sys.usb.config=mtp" "persist.sys.usb.config=mtp,adb";
insert_line default.prop "persist.service.adb.enable=1" after "persist.sys.usb.config=mtp,adb" "persist.service.adb.enable=1";
insert_line default.prop "persist.adb.notify=0" after "persist.service.adb.enable=1" "persist.adb.notify=0";
insert_line default.prop "ro.securestorage.support=false" after "debug.atrace.tags.enableflags=0" "ro.securestorage.support=false";

# Ramdisk changes - fstab.goldfish
replace_string fstab.goldfish "/dev/block/mtdblock0                                    /system             ext4      ro,noatime,barrier=1                                 wait" "/dev/block/mtdblock0                                    /system             ext4      ro,barrier=1                                         wait" "/dev/block/mtdblock0                                    /system             ext4      ro,noatime,barrier=1                                 wait";

# Ramdisk changes - fstab.ranchu
replace_string fstab.ranchu "/dev/block/vda                                          /system             ext4      ro,noatime                                           wait" "/dev/block/vda                                          /system             ext4      ro                                                   wait" "/dev/block/vda                                          /system             ext4      ro,noatime                                           wait";

# Ramdisk changes - init.rc
insert_line init.rc "import /init.services.rc" after "import /init.fac.rc" "import /init.services.rc";

# Ramdisk changes - init.samsungexynos8890.rc
insert_line init.samsungexynos8890.rc "    mount f2fs /dev/block/platform/155a0000.ufs/by-name/SYSTEM /system wait ro" after "    mount ext4 /dev/block/platform/155a0000.ufs/by-name/SYSTEM /system wait ro" "    mount f2fs /dev/block/platform/155a0000.ufs/by-name/SYSTEM /system wait ro";
insert_line init.samsungexynos8890.rc "service visiond /system/bin/visiond" after "start secure_storage" "\n# AIR\nservice visiond /system/bin/visiond\n    class main\n    user system\n    group system camera media media_rw\n# faced\nservice faced /system/bin/faced\n    class late_start\n    user system\n    group system\n\n# irisd\nservice irisd /system/bin/irisd\n    class late_start\n    user system\n    group system";

# Ramdisk changes - Spectrum
if egrep -q "install=1" "/tmp/aroma/spectrum.prop"; then
	ui_print "- Adding Spectrum";
	replace_file sbin/spa 755 spectrum/spa;
	replace_file init.spectrum.rc 644 spectrum/init.spectrum.rc;
	replace_file init.spectrum.sh 644 spectrum/init.spectrum.sh;
	insert_line init.rc "import /init.spectrum.rc" after "import /init.services.rc" "import /init.spectrum.rc";
fi;

# Ramdisk changes - PWMFix
if egrep -q "install=1" "/tmp/aroma/pwm.prop"; then
	ui_print "- Enabling PWMFix by default";
	replace_string sbin/kernelinit.sh "echo \"1\" > /sys/class/lcd/panel/smart_on" "echo \"0\" > /sys/class/lcd/panel/smart_on" "echo \"1\" > /sys/class/lcd/panel/smart_on";
fi;

# Ramdisk changes - SELinux (Fake) Enforcing Mode
if egrep -q "install=1" "/tmp/aroma/selinux.prop"; then
	ui_print "- Enabling SELinux Enforcing Mode";
	replace_string sbin/kernelinit.sh "echo \"1\" > /sys/fs/selinux/enforce" "echo \"0\" > /sys/fs/selinux/enforce" "echo \"1\" > /sys/fs/selinux/enforce";
fi;

# Ramdisk Advanced Options
if egrep -q "install=1" "/tmp/aroma/advanced.prop"; then

# Ramdisk changes for CPU Governors (Big)
	sed -i -- "s/governor-big=//g" /tmp/aroma/governor-big.prop
	GOVERNOR_BIG=`cat /tmp/aroma/governor-big.prop`
	if [[ "$GOVERNOR_BIG" != "interactive" ]]; then
		ui_print "- Setting CPU Big Freq Governor to $GOVERNOR_BIG";
		insert_line sbin/kernelinit.sh "echo $GOVERNOR_BIG > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor" after "# Customisations" "echo $GOVERNOR_BIG > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor";
	fi

# Ramdisk changes for CPU Governors (Little)
	sed -i -- "s/governor-little=//g" /tmp/aroma/governor-little.prop
	GOVERNOR_LITTLE=`cat /tmp/aroma/governor-little.prop`
	if [[ "$GOVERNOR_LITTLE" != "interactive" ]]; then
		ui_print "- Setting CPU Little Freq Governor to $GOVERNOR_LITTLE";
		insert_line sbin/kernelinit.sh "echo $GOVERNOR_LITTLE > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" after "# Customisations" "echo $GOVERNOR_LITTLE > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor";
	fi

# Ramdisk changes for IO Schedulers (Internal)
	sed -i -- "s/scheduler-internal=//g" /tmp/aroma/scheduler-internal.prop
	SCHEDULER_INTERNAL=`cat /tmp/aroma/scheduler-internal.prop`
	if [[ "$SCHEDULER_INTERNAL" != "cfq" ]]; then
		ui_print "- Setting Internal IO Scheduler to $SCHEDULER_INTERNAL";
		insert_line sbin/kernelinit.sh "echo $SCHEDULER_INTERNAL > /sys/block/sda/queue/scheduler" after "# Customisations" "echo $SCHEDULER_INTERNAL > /sys/block/sda/queue/scheduler";
	fi

# Ramdisk changes for IO Schedulers (External)
	sed -i -- "s/scheduler-external=//g" /tmp/aroma/scheduler-external.prop
	SCHEDULER_EXTERNAL=`cat /tmp/aroma/scheduler-external.prop`
	if [[ "$SCHEDULER_EXTERNAL" != "cfq" ]]; then
		ui_print "- Setting External IO Scheduler to $SCHEDULER_EXTERNAL";
		insert_line sbin/kernelinit.sh "echo $SCHEDULER_EXTERNAL > /sys/block/mmcblk0/queue/scheduler" after "# Customisations" "echo $SCHEDULER_EXTERNAL > /sys/block/mmcblk0/queue/scheduler";
	fi

# Ramdisk changes for TCP Congestion Algorithms
	sed -i -- "s/tcp=//g" /tmp/aroma/tcp.prop
	TCP=`cat /tmp/aroma/tcp.prop`
	if [[ "$TCP" != "bic" ]]; then
		ui_print "- Setting TCP Congestion Algorithm to $TCP";
		insert_line sbin/kernelinit.sh "echo $TCP > /proc/sys/net/ipv4/tcp_congestion_control" after "# Customisations" "echo $TCP > /proc/sys/net/ipv4/tcp_congestion_control";
	fi

fi

# End ramdisk changes
ui_print "- Writing Boot Image";
write_boot;

## End install

