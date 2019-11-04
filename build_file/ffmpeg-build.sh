#!/bin/bash

OUTPUTPATH=android_libs
NDK=/Users/wuhan/Library/Android/sdk/ndk
TOOLCHAIN=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64
API=21

MIN_PLATFORM=${NDK}/platforms/android-${API}
ADDI_LDFLAGS="-Wl,-rpath-link=$MIN_PLATFORM/arch-arm/usr/lib -L$MIN_PLATFORM/arch-arm/usr/lib -nostdlib"

function build_android
{
echo "Compiling FFmpeg for $CPU"
./configure \
    --prefix=${PREFIX} \
    --disable-neon \
    --disable-hwaccels \
    --disable-gpl \
    --disable-postproc \
    --enable-shared \
    --enable-jni \
    --disable-mediacodec \
    --disable-decoder=h264_mediacodec \
    --disable-static \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-avdevice \
    --disable-doc \
    --disable-symver \
    --cross-prefix=${CROSS_PREFIX} \
    --target-os=android \
    --arch=${ARCH} \
    --cpu=${CPU} \
    --cc=${CC} \
    --cxx=${CXX} \
    --enable-cross-compile \
    --sysroot=${SYSROOT} \
    --extra-cflags="-Os -fpic ${OPTIMIZE_CFLAGS}" \
    --extra-ldflags="${ADDI_LDFLAGS}" \
    ${ADDITIONAL_CONFIGURE_FLAG}
make clean
make
make install
echo "The Compilation of FFmpeg for ${CPU} is completed"
}

#armv8-a
ARCH=arm64
CPU=armv8-a
CC=${TOOLCHAIN}/bin/aarch64-linux-android${API}-clang
CXX=${TOOLCHAIN}/bin/aarch64-linux-android${API}-clang++
SYSROOT=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
CROSS_PREFIX=${TOOLCHAIN}/bin/aarch64-linux-android-
PREFIX=${OUTPUTPATH}/${CPU}
OPTIMIZE_CFLAGS="-march=${CPU}"
build_android

#armv7-a
ARCH=arm
CPU=armv7-a
CC=${TOOLCHAIN}/bin/armv7a-linux-androideabi${API}-clang
CXX=${TOOLCHAIN}/bin/armv7a-linux-androideabi${API}-clang++
SYSROOT=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
CROSS_PREFIX=${TOOLCHAIN}/bin/arm-linux-androideabi-
PREFIX=${OUTPUTPATH}/${CPU}
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=${CPU}"
build_android

#x86
ARCH=x86
CPU=x86
CC=${TOOLCHAIN}/bin/i686-linux-android${API}-clang
CXX=${TOOLCHAIN}/bin/i686-linux-android${API}-clang++
SYSROOT=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
CROSS_PREFIX=${TOOLCHAIN}/bin/i686-linux-android-
PREFIX=${OUTPUTPATH}/${CPU}
OPTIMIZE_CFLAGS="-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
build_android

#x86_64
ARCH=x86_64
CPU=x86-64
CC=${TOOLCHAIN}/bin/x86_64-linux-android${API}-clang
CXX=${TOOLCHAIN}/bin/x86_64-linux-android${API}-clang++
SYSROOT=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
CROSS_PREFIX=${TOOLCHAIN}/bin/x86_64-linux-android-
PREFIX=${OUTPUTPATH}/${CPU}
OPTIMIZE_CFLAGS="-march=${CPU} -msse4.2 -mpopcnt -m64 -mtune=intel"
build_android


NDK=/Users/wuhan/Library/Android/sdk/ndk # NDK目录，自行修改
API=21
# arm aarch64 i686 x86_64  进行修改
ARCH=aarch64
# armv7a aarch64 i686 x86_64  进行修改
PLATFORM=aarch64
TARGET=$PLATFORM-linux-android
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64/bin # 这里找到对应得文件
SYSROOT=$NDK/platforms/android-${API}/arch-arm64
PREFIX=${OUTPUTPATH}/${ARCH}

CFLAG="-D__ANDROID_API__=$API -U_FILE_OFFSET_BITS -DBIONIC_IOCTL_NO_SIGNEDNESS_OVERLOAD -Os -fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -marm"

build_one()
{
echo "Compiling FFmpeg for $ARCH"
./configure \
--ln_s="cp -rf" \
--prefix=$PREFIX \
--cc=$TOOLCHAIN/$TARGET$API-clang \
--cxx=$TOOLCHAIN/$TARGET$API-clang++ \
--ld=$TOOLCHAIN/$TARGET$API-clang \
--target-os=android \
--arch=$ARCH \
--cross-prefix=$TOOLCHAIN/$ARCH-linux-android- \
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
echo "The Compilation of FFmpeg for ${ARCH} is completed"
}

build_one