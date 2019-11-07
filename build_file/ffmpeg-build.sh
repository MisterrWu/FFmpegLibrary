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
--disable-shared \
--enable-static \
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
--enable-network \
--disable-decoders --enable-decoder=hevc --enable-decoder=h264 --enable-decoder=g711 --enable-decoder=aac \
--disable-encoders --enable-encoder=hevc --enable-encoder=h264 --enable-encoder=g711 --enable-encoder=aac \
--disable-demuxers --enable-demuxer=rtsp --enable-demuxer=rtp --enable-demuxer=h264 --enable-demuxer=hevc \
--disable-muxers --enable-muxer=hevc --enable-muxer=h264 --enable-muxer=g711 --enable-muxer=aac \
--disable-parsers --enable-parser=aac --enable-parser=g711 --enable-parser=h264 --enable-parser=hevc --enable-hwaccel=hevc_dxva2 --enable-hwaccel=h264_dxva2 \
--disable-protocols --enable-protocol=rtmp --enable-protocol=rtp --enable-protocol=tcp --enable-protocol=udp --enable-protocol=file  \
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

echo "Merge static libraries for ${CPU} is started"
${TOOLCHAIN_LD} \
-rpath-link=${PLATFORM_LIB} \
-L${PLATFORM_LIB} \
-L${PREFIX}/lib \
-soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
${PREFIX}/libffmpeg.so \
    ${PREFIX}/lib/libavcodec.a \
    ${PREFIX}/lib/libavdevice.a \
    ${PREFIX}/lib/libavfilter.a \
    ${PREFIX}/lib/libavformat.a \
    ${PREFIX}/lib/libavutil.a \
    ${PREFIX}/lib/libswresample.a \
    ${PREFIX}/lib/libswscale.a \
    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
    ${LIBGCC}/libgcc_real.a
# 精简库
${STRIP} ${PREFIX}/libffmpeg.so
echo "Merge static libraries for ${CPU} is completed"
}

# arm64-v8a
ARCH=aarch64
CPU=arm64-v8a
TARGET=${ARCH}-linux-android
TOOLCHAIN=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/bin # 这里找到对应得文件
PREFIX=${OUTPUTPATH}/${CPU}
CROSS_PREFIX=${TOOLCHAIN}/${ARCH}-linux-android-
TOOLCHAIN_LD=${TOOLCHAIN}/${ARCH}-linux-android-ld
PLATFORM=${NDK}/platforms/android-${API}/arch-arm64
PLATFORM_LIB=${PLATFORM}/usr/lib
LIBGCC=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/lib/gcc/${ARCH}-linux-android/4.9.x
STRIP=${TOOLCHAIN}/${ARCH}-linux-android-strip
build_one

# armeabi-v7a
ARCH=armv7a
CPU=armeabi-v7a
TARGET=${ARCH}-linux-androideabi
TOOLCHAIN=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/bin # 这里找到对应得文件
PREFIX=${OUTPUTPATH}/${CPU}
CROSS_PREFIX=${TOOLCHAIN}/arm-linux-androideabi-
TOOLCHAIN_LD=${TOOLCHAIN}/arm-linux-androideabi-ld
PLATFORM=${NDK}/platforms/android-${API}/arch-arm
PLATFORM_LIB=${PLATFORM}/usr/lib
LIBGCC=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9.x
STRIP=${TOOLCHAIN}/arm-linux-androideabi-strip
build_one

# x86
ARCH=i686
CPU=x86
TARGET=${ARCH}-linux-android
TOOLCHAIN=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/bin # 这里找到对应得文件
PREFIX=${OUTPUTPATH}/${CPU}
CROSS_PREFIX=${TOOLCHAIN}/${ARCH}-linux-android-
TOOLCHAIN_LD=${TOOLCHAIN}/${ARCH}-linux-android-ld
PLATFORM=${NDK}/platforms/android-${API}/arch-x86
PLATFORM_LIB=${PLATFORM}/usr/lib
LIBGCC=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/lib/gcc/${ARCH}-linux-android/4.9.x
STRIP=${TOOLCHAIN}/${ARCH}-linux-android-strip
build_one

# x86_64
ARCH=x86_64
CPU=x86_64
TARGET=${ARCH}-linux-android
TOOLCHAIN=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/bin # 这里找到对应得文件
PREFIX=${OUTPUTPATH}/${CPU}
CROSS_PREFIX=${TOOLCHAIN}/${ARCH}-linux-android-
TOOLCHAIN_LD=${TOOLCHAIN}/${ARCH}-linux-android-ld
PLATFORM=${NDK}/platforms/android-${API}/arch-x86_64
PLATFORM_LIB=${PLATFORM}/usr/lib64
LIBGCC=${NDK}/toolchains/llvm/prebuilt/darwin-x86_64/lib/gcc/${ARCH}-linux-android/4.9.x
STRIP=${TOOLCHAIN}/${ARCH}-linux-android-strip
build_one