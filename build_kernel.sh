#!/bin/bash

KERNEL_NAME="Prophecy_Kernel"
KERNEL_VERSION="1.0.0"
KERNEL_REVISION="0"
KERNEL_BETA="1"

if [ $KERNEL_BETA == 1 ]; then
	KERNEL_VERSION+=β
fi
if [ $KERNEL_REVISION != 0 ]; then
	KERNEL_VERSION+=-r$KERNEL_REVISION
fi
export LOCALVERSION=-${KERNEL_NAME}-v${KERNEL_VERSION}

export ARCH=arm64
export CROSS_COMPILE=../aarch64-linux-android-4.9/bin/aarch64-linux-android-

make prophecy-hero2lteeur_defconfig
make -j4 2>&1 | tee -a ./build_kernel.log
