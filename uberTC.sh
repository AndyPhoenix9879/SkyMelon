#!/bin/bash
TIMESTAMP=`date +"%d%m%Y"`
LGREEN='\033[1;32m'
GREEN='\033[0;32m'
WHITE='\033[1;37m'
PINK='\033[1;35m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NCOLOR='\033[0m'

export CROSS_COMPILE=/media/lai/89691967-1da1-4925-aefa-273bc0864b75/aarch64-linux-android-4.9-kernel/bin/aarch64-linux-android-

echo -e "${WHITE}Cleaning up${NCOLOR}"
make mrproper
rm *.img
#To do: find a workaround for the .dtb's not being deleted
rm $(find -name '*.dtb')
echo ""

echo -e "${PINK}Compiling for tulip${NCOLOR}"
make ARCH=arm64 CROSS_COMPILE=$CROSS_COMPILE tulip_defconfig
echo ""

echo -e "${BLUE}Compiling the kernel${NCOLOR}"
echo ""
time make ARCH=arm64 CROSS_COMPILE=$CROSS_COMPILE -j$(grep -c ^processor /proc/cpuinfo)
echo ""

echo -e "${WHITE}Image built. Copying Image..${WHITE}"
echo ""
cp /media/lai/89691967-1da1-4925-aefa-273bc0864b75/SkyMelon/arch/arm64/boot/Image.gz-dtb /media/lai/89691967-1da1-4925-aefa-273bc0864b75/Kernelcooking/mkbootimg_tools/boot.all

echo ""

echo -e "${WHITE}Building the boot.img for all variant${WHITE}"
echo ""
cd /media/lai/89691967-1da1-4925-aefa-273bc0864b75/Kernelcooking/mkbootimg_tools/
./mkbootimg --cmdline "console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk" --base 0x81dfff00 --kernel /media/lai/89691967-1da1-4925-aefa-273bc0864b75/Kernelcooking/mkbootimg_tools/boot.all/Image.gz-dtb --ramdisk /media/lai/89691967-1da1-4925-aefa-273bc0864b75/Kernelcooking/mkbootimg_tools/boot.all/ramdisk.packed --ramdisk_offset 0x82000000 --pagesize 2048 --tags_offset 0x81E00000 -o SkyMelonv5-allvariant.img

echo ""

echo -e "${WHITE}Finalizing${WHITE}"
echo ""
cp /media/lai/89691967-1da1-4925-aefa-273bc0864b75/Kernelcooking/mkbootimg_tools/SkyMelonv5-allvariant.img /media/lai/89691967-1da1-4925-aefa-273bc0864b75/Kernelcooking/SkyMelonV5

echo ""

echo -e "${GREEN}The boot.img has been built successfully!${NCOLOR}"
