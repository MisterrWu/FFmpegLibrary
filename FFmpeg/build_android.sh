#!/bin/bash
# 清空上次的编译
make clean
#你自己的NDK路径。
export NDK=/Users/wuhan/Library/Android/sdk/ndk
# 设置你的android平台编译器的版本 这里采用Android4.0
export SYSROOT=$NDK/platforms/android-26/arch-arm/
#编译使用的toolchain
export TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
export CPU=armv7-a
# 这个是输出的路径
export PREFIX=$(pwd)/android/$CPU
export ADDI_CFLAGS="-marm"
./configure --target-os=android \
--prefix=$PREFIX --arch=arm \
--disable-doc \
--enable-shared \
--disable-static \
--disable-x86asm \
--disable-symver \
--enable-gpl \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-doc \
--disable-symver \
--cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
--enable-cross-compile \
--sysroot=$SYSROOT \
--extra-cflags="-Os -fpic $ADDI_CFLAGS" \
--extra-ldflags="$ADDI_LDFLAGS" \
$ADDITIONAL_CONFIGURE_FLAG
make clean
make
make install