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
cp /media/lai/89691967-1da1-4925-aefa-273bc0864b75/SkyMelon/arch/arm64/boot/Image /media/lai/89691967-1da1-4925-aefa-273bc0864b75/Kernelcooking/mkbootimg_tools/boot.e/kernel

echo ""

echo -e "${WHITE}Building the boot.img for all variant${WHITE}"
echo ""
cd /media/lai/89691967-1da1-4925-aefa-273bc0864b75/SkyMelon
./dtbToolCM -2 -o /media/lai/89691967-1da1-4925-aefa-273bc0864b75/Kernelcooking/mkbootimg_tools/boot.e/dt.img -s 2048 -p /media/lai/89691967-1da1-4925-aefa-273bc0864b75/SkyMelon/scripts/dtc/ /media/lai/89691967-1da1-4925-aefa-273bc0864b75/SkyMelon/arch/arm/boot/dts/

cd /media/lai/89691967-1da1-4925-aefa-273bc0864b75/Kernelcooking/mkbootimg_tools/
./mkboot boot.e boot.img

echo ""

echo -e "${WHITE}Copying to 'assembly folder'${WHITE}"
echo ""
cp /media/lai/89691967-1da1-4925-aefa-273bc0864b75/Kernelcooking/mkbootimg_tools/boot.img /media/lai/89691967-1da1-4925-aefa-273bc0864b75/build_tools
cp /media/lai/89691967-1da1-4925-aefa-273bc0864b75/SkyMelon/drivers/staging/prima/wlan.ko /media/lai/89691967-1da1-4925-aefa-273bc0864b75/build_tools

echo -e "${WHITE}Building the zip file${WHITE}"
echo ""
cd /media/lai/89691967-1da1-4925-aefa-273bc0864b75/build_tools
./packzip.sh

echo -e "${WHITE}Finalizing..${WHITE}"
echo ""
cd /media/lai/89691967-1da1-4925-aefa-273bc0864b75/build_tools/
zip -m 7e.zip boot.img
#cp /media/lai/89691967-1da1-4925-aefa-273bc0864b75/build_tools/V7.img /media/lai/89691967-1da1-4925-#aefa-273bc0864b75/build_tools/7e.zip

echo -e "${GREEN}The kernel has been built successfully!${NCOLOR}"
