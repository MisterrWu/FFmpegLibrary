#!/bin/bash

OUTPUTPATH=android_libs
NDK=/Users/wuhan/Library/Android/sdk/ndk # NDK目录，自行修改
API=21

CFLAG="-D__ANDROID_API__=$API -U_FILE_OFFSET_BITS -DBIONIC_IOCTL_NO_SIGNEDNESS_OVERLOAD -Os -fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -marm"

function build_one()
{
echo "Compiling FFmpeg for ${CPU}"
./configure \
--ln_s="cp -rf" \
--prefix=${PREFIX} \
--cc=${TOOLCHAIN}/${TARGET}${API}-clang \
--cxx=${TOOLCHAIN}/${TARGET}${API}-clang++ \
--ld=${TOOLCHAIN}/${TARGET}${API}-clang \
--target-os=android \
--arch=${ARCH} \
--cross-prefix=${CROSS_PREFIX} \
--disable-asm \
--enable-cross-compile \
--enable-shared \
--disable-static \
--enable-runtime-cpudetect \
--disable-doc \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-doc \
--disable-symver \
--enable-small \
--enable-gpl --enable-nonfree --enable-version3 --disable-iconv \
--enable-jni \
--enable-mediacodec \
--disable-decoders --enable-decoder=vp9 --enable-decoder=h264 --enable-decoder=mpeg4 --enable-decoder=aac \
--disable-encoders --enable-encoder=h264_v4l2m2m \
--disable-demuxers --enable-demuxer=rtsp --enable-demuxer=rtp --enable-demuxer=flv --enable-demuxer=h264 \
--disable-muxers --enable-muxer=rtsp --enable-muxer=rtp --enable-muxer=flv --enable-muxer=h264 \
--disable-parsers --enable-parser=mpeg4video --enable-parser=aac --enable-parser=h264 --enable-parser=vp9 \
--disable-protocols --enable-protocol=rtmp --enable-protocol=rtp --enable-protocol=tcp --enable-protocol=udp \
--disable-bsfs \
--disable-indevs --enable-indev=v4l2 \
--disable-outdevs \
--disable-filters \
--disable-postproc \
--extra-cflags="$CFLAG" \
--extra-ldflags="-marm"

make clean
make
make install
echo "The Compilation of FFmpeg for ${CPU} is completed"
}

# arm64-v8a
ARCH=aarch64
CPU=arm64-v8a
TARGET=${ARCH}-linux-android
TOOLCHAIN=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/bin # 这里找到对应得文件
PREFIX=${OUTPUTPATH}/${CPU}
CROSS_PREFIX=${TOOLCHAIN}/${ARCH}-linux-android-
build_one

# armeabi-v7a
ARCH=armv7a
CPU=armeabi-v7a
TARGET=${ARCH}-linux-androideabi
TOOLCHAIN=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/bin # 这里找到对应得文件
PREFIX=${OUTPUTPATH}/${CPU}
CROSS_PREFIX=${TOOLCHAIN}/arm-linux-androideabi-
build_one

# x86
ARCH=i686
CPU=x86
TARGET=${ARCH}-linux-android
TOOLCHAIN=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/bin # 这里找到对应得文件
PREFIX=${OUTPUTPATH}/${CPU}
CROSS_PREFIX=${TOOLCHAIN}/${ARCH}-linux-android-
build_one

# x86_64
ARCH=x86_64
CPU=x86_64
TARGET=${ARCH}-linux-android
TOOLCHAIN=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/bin # 这里找到对应得文件
PREFIX=${OUTPUTPATH}/${CPU}
CROSS_PREFIX=${TOOLCHAIN}/${ARCH}-linux-android-
build_one