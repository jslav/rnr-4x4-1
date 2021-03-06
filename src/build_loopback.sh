#!/bin/sh

. ./toolchain_path
. ./color

ROOTDIR=$PWD

cecho y "*** Building v4l2loopback ***"

KPATH_FILE=$ROOTDIR/kernel_path
KERNEL=$(cat "$KPATH_FILE") 
LOOPBACK=$PWD/v4l2loopback
CROSS_COMPILE=arm-linux-gnueabihf-

if [ -d $LOOPBACK ]; then
  make -C $LOOPBACK -f Makefile.loopback clean
else
  git clone https://github.com/umlaeute/v4l2loopback.git
  if [ $? -ne 0 ]; then
    cecho r "!!! Failed to clone video loopback driver"
    exit 1
  fi
fi

mkdir -p usr/lib

cp Makefile.loopback $LOOPBACK
cd $LOOPBACK

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- KERNEL_PATH=$KERNEL -f Makefile.loopback
if [ $? -ne 0 ]; then
  cecho r "!!! Failed to build loopback driver"
  exit 1
fi

cp v4l2loopback.ko $ROOTDIR/usr/lib

cecho g "!!! v4l2loopback done !!!\n"
