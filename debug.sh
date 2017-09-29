#!/bin/bash

tput reset
adb shell dmesg 2>&1 | tee -a ./dmesg.log
tput reset
adb logcat 2>&1 | tee -a ./logcat.log
