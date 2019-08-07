#!/bin/sh

X15_ANDROID_DIR=overlays/fileserver/wwwroot/x15/android
X15_OE_DIR=overlays/fileserver/wwwroot/x15/OE

mkdir overlays/fileserver/wwwroot/x15
mkdir ${X15_ANDROID_DIR}
mkdir ${X15_OE_DIR}

wget -O ${X15_ANDROID_DIR}/vendor.img https://images.validation.linaro.org/snapshots.linaro.org/android/lkft/lkft-x15-aosp-4.14/239/vendor.img
wget -O ${X15_ANDROID_DIR}/boot_fit.img https://images.validation.linaro.org/snapshots.linaro.org/android/lkft/lkft-x15-aosp-4.14/239/boot_fit.img
wget -O ${X15_ANDROID_DIR}/userdata.img https://images.validation.linaro.org/snapshots.linaro.org/android/lkft/lkft-x15-aosp-4.14/239/userdata.img
wget -O ${X15_ANDROID_DIR}/system.img https://images.validation.linaro.org/snapshots.linaro.org/android/lkft/lkft-x15-aosp-4.14/239/system.img

wget -O ${X15_OE_DIR}/rpb-console-image-am57xx-evm-20180205221320-631.rootfs.img.gz http://images.validation.linaro.org/snapshots.linaro.org/openembedded/lkft/morty/am57xx-evm/rpb/linux-mainline/631/rpb-console-image-am57xx-evm-20180205221320-631.rootfs.img.gz
