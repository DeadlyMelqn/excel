#!/bin/bash

export ARCH=arm64
export CROSS_COMPILE=../aarch64-linux-android-4.9/bin/aarch64-linux-android-

make exynos8890-hero2lte_defconfig
make -j4 2>&1 | tee -a ./build_kernel.log
