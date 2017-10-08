# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() {
kernel.string=Excel Kernel @ Yuv
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=herolte
device.name2=heroltebmc
device.name3=herolteskt
device.name4=heroltelgt
device.name5=heroltektt
} # end properties

# shell variables
block=/dev/block/platform/155a0000.ufs/by-name/BOOT;
is_slot_device=0;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel permissions
# set permissions for included ramdisk files
chmod 750 $ramdisk/init.services.rc
chmod 750 $ramdisk/init.kernelconf.rc
chmod 750 $ramdisk/sbin/sepolicy.sh
chmod 750 $ramdisk/sbin/sysinit.sh
chmod 750 $ramdisk/fstab.samsungexynos8890


## AnyKernel install
dump_boot;

# begin ramdisk changes

insert_line default.prop "ro.sys.sdcardfs=false" after "debug.atrace.tags.enableflags=0" "ro.sys.sdcardfs=false";

# init.samsungexynos8890.rc
insert_line init.samsungexynos8890.rc "import init.services.rc" after "import init.remove_recovery.rc" "import init.services.rc";

# end ramdisk changes

write_boot;

## end install
