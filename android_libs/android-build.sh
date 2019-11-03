#!/bin/bash
function build1() {
NDK=/home/junt/Documents/android-ndk-r20
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64/
#这里修改的是最低支持的android sdk版本（r20版本ndk中armv8a、x86_64最低支持21，armv7a、x86最低支持16）
API=29
#armv8-a
ARCH=arm64
CPU=armv8-a
#r20版本的ndk中所有的编译器都在/android-ndk-r20/toolchains/llvm/prebuilt/linux-x86_64/目录下（clang）
CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
#头文件环境用的不是/android-ndk-r20/sysroot,而是编译器//android-ndk-r20/toolchains/llvm/prebuilt/linux-x86_64/sysroot
SYSROOT=$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot
#交叉编译工具目录,对应关系如下(不明白的可以看下图)
# armv8a -> arm64 -> aarch64-linux-android-
# armv7a -> arm -> arm-linux-androideabi-
# x86 -> x86 -> i686-linux-android-
# x86_64 -> x86_64 -> x86_64-linux-android-
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
#输出目录
PREFIX=$(pwd)/android/$CPU
OPTIMIZE_CFLAGS="-march=$CPU"
#相当于Android中Log.i
echo "Compiling FFmpeg for $CPU"
#调用同级目录下的configure文件
./configure \
#指定输出目录
    --prefix=$PREFIX \
#各种配置项，想详细了解的可以打开configure文件找到Help options:查看
    --disable-neon \
    --disable-hwaccels \
    --disable-gpl \
    --disable-postproc \
#配置跨平台编译，同时需要disable-static
    --enable-shared \
    --enable-jni \
    --disable-mediacodec \
    --disable-decoder=h264_mediacodec \
#配置跨平台编译，同时需enable-shared
    --disable-static \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-avdevice \
    --disable-doc \
    --disable-symver \
#关键点1.指定交叉编译工具目录
    --cross-prefix=$CROSS_PREFIX \
#关键点2.指定目标平台为android
    --target-os=android \
#关键点3.指定cpu类型
    --arch=$ARCH \
#关键点4.指定cpu架构
    --cpu=$CPU \
#超级关键点5.指定c语言编译器
    --cc=$CC
    --cxx=$CXX
#关键点6.开启交叉编译
    --enable-cross-compile \
#超级关键7.配置编译环境c语言的头文件环境
    --sysroot=$SYSROOT \
    --extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG
make clean
make
make install
echo "The Compilation of FFmpeg for $CPU is completed"
}

function build_android
{
echo "Compiling FFmpeg for $CPU"
./configure \
    --prefix=$PREFIX \
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
    --cross-prefix=$CROSS_PREFIX \
    --target-os=android \
    --arch=$ARCH \
    --cpu=$CPU \
    --cc=$CC
    --cxx=$CXX
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG
make clean
make
make install
echo "The Compilation of FFmpeg for $CPU is completed"
}

function build2() {
NDK=/Users/wuhan/Library/Android/sdk/ndk
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
API=29

:'
#armv8-a
ARCH=arm64
CPU=armv8-a
CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
SYSROOT=$NDK/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
PREFIX=$(pwd)/android/$CPU
OPTIMIZE_CFLAGS="-march=$CPU"
build_android

#armv7-a
ARCH=arm
CPU=armv7-a
CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
SYSROOT=$NDK/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
PREFIX=$(pwd)/android/$CPU
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "
build_android

#x86
ARCH=x86
CPU=x86
CC=$TOOLCHAIN/bin/i686-linux-android$API-clang
CXX=$TOOLCHAIN/bin/i686-linux-android$API-clang++
SYSROOT=$NDK/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/i686-linux-android-
PREFIX=$(pwd)/android/$CPU
OPTIMIZE_CFLAGS="-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
build_android
'

#x86_64
ARCH=x86_64
CPU=x86-64
CC=$TOOLCHAIN/bin/x86_64-linux-android$API-clang
CXX=$TOOLCHAIN/bin/x86_64-linux-android$API-clang++
SYSROOT=$NDK/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/x86_64-linux-android-
PREFIX=$(pwd)/android/$CPU
OPTIMIZE_CFLAGS="-march=$CPU -msse4.2 -mpopcnt -m64 -mtune=intel"
build_android
}

function build3() {
# NDK 根目录
export NDK=/Users/summer/Library/Android/sdk/ndk/20.0.5594570
# 当前系统
export HOST_TAG=darwin-x86_64
# 支持的 Android CUP 架构
# export ARCH=aarch64
# export CPU=armv8-a
export ARCH=armv7a
export CPU=armv7-a
# 支持的 Android 最低系统版本
export MIN=21
export ANDROID_NDK_PLATFORM=android-21

export PREFIX=$(pwd)/android/$CPU

export MIN_PLATFORM=$NDK/platforms/android-$MIN
export SYSROOT=$NDK/sysroot
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
export AR=$TOOLCHAIN/bin/arm-linux-androideabi-ar
export AS=$TOOLCHAIN/bin/arm-linux-androideabi-as
export CC=$TOOLCHAIN/bin/$ARCH-linux-androideabi$MIN-clang
export CXX=$TOOLCHAIN/bin/$ARCH-linux-androideabi$MIN-clang++
export LD=$TOOLCHAIN/bin/arm-linux-androideabi-ld
export NM=$TOOLCHAIN/bin/arm-linux-androideabi-nm
export RANLIB=$TOOLCHAIN/bin/arm-linux-androideabi-ranlib
export STRIP=$TOOLCHAIN/bin/arm-linux-androideabi-strip

OPTIMIZE_CFLAGS="-DANDROID -I$NDK/sysroot/usr/include/arm-linux-androideabi/"
ADDI_LDFLAGS="-Wl,-rpath-link=$MIN_PLATFORM/arch-arm/usr/lib -L$MIN_PLATFORM/arch-arm/usr/lib -nostdlib"

sed  -i "" "s/SLIBNAME_WITH_MAJOR='\$(SLIBNAME).\$(LIBMAJOR)'/SLIBNAME_WITH_MAJOR='\$(SLIBPREF)\$(FULLNAME)-\$(LIBMAJOR)\$(SLIBSUF)'/" configure
sed  -i "" "s/LIB_INSTALL_EXTRA_CMD='\$\$(RANLIB) \"\$(LIBDIR)\\/\$(LIBNAME)\"'/LIB_INSTALL_EXTRA_CMD='\$\$(RANLIB) \"\$(LIBDIR)\\/\$(LIBNAME)\"'/" configure
sed  -i "" "s/SLIB_INSTALL_NAME='\$(SLIBNAME_WITH_VERSION)'/SLIB_INSTALL_NAME='\$(SLIBNAME_WITH_MAJOR)'/" configure
sed  -i "" "s/SLIB_INSTALL_LINKS='\$(SLIBNAME_WITH_MAJOR) \$(SLIBNAME)'/SLIB_INSTALL_LINKS='\$(SLIBNAME)'/" configure
# sed  -i "" "s/SHFLAGS='-shared -Wl,-soname,\$(SLIBNAME)'/SHFLAGS='-shared -soname \$(SLIBNAME)'/" configure
# sed  -i "" "s/-Wl//g" configure

./configure \
--prefix=$PREFIX \
--ar=$AR \
--as=$AS \
--cc=$CC \
--cxx=$CXX \
--nm=$NM \
--ranlib=$RANLIB \
--strip=$STRIP \
--arch=$ARCH \
--target-os=android \
--enable-cross-compile \
--disable-asm \
--enable-shared \
--disable-static \
--disable-ffprobe \
--disable-ffplay \
--disable-ffmpeg \
--disable-debug \
--disable-symver \
--disable-stripping \
--extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS" \
--extra-ldflags="$ADDI_LDFLAGS"

sed  -i "" "s/#define HAVE_TRUNC 0/#define HAVE_TRUNC 1/" config.h
sed  -i "" "s/#define HAVE_TRUNCF 0/#define HAVE_TRUNCF 1/" config.h
sed  -i "" "s/#define HAVE_RINT 0/#define HAVE_RINT 1/" config.h
sed  -i "" "s/#define HAVE_LRINT 0/#define HAVE_LRINT 1/" config.h
sed  -i "" "s/#define HAVE_LRINTF 0/#define HAVE_LRINTF 1/" config.h
sed  -i "" "s/#define HAVE_ROUND 0/#define HAVE_ROUND 1/" config.h
sed  -i "" "s/#define HAVE_ROUNDF 0/#define HAVE_ROUNDF 1/" config.h
sed  -i "" "s/#define HAVE_CBRT 0/#define HAVE_CBRT 1/" config.h
sed  -i "" "s/#define HAVE_CBRTF 0/#define HAVE_CBRTF 1/" config.h
sed  -i "" "s/#define HAVE_COPYSIGN 0/#define HAVE_COPYSIGN 1/" config.h
sed  -i "" "s/#define HAVE_ERF 0/#define HAVE_ERF 1/" config.h
sed  -i "" "s/#define HAVE_HYPOT 0/#define HAVE_HYPOT 1/" config.h
sed  -i "" "s/#define HAVE_ISNAN 0/#define HAVE_ISNAN 1/" config.h
sed  -i "" "s/#define HAVE_ISFINITE 0/#define HAVE_ISFINITE 1/" config.h
sed  -i "" "s/#define HAVE_INET_ATON 0/#define HAVE_INET_ATON 1/" config.h
sed  -i "" "s/#define getenv(x) NULL/\\/\\/ #define getenv(x) NULL/" config.h
}

function build4() {
NDK=/Users/wuhan/Library/Android/sdk/ndk
API=22
ARCH=aarch64
PLATFORM=aarch64
TARGET=$PLATFORM-linux-android
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64/bin
#正确的sysroot
SYSROOT=$NDK/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
CPU=aarch64
PREFIX=/Documents/works/gits/Android/FFmpegLibrary/FFmpeg/android/$CPU
CFLAG="-D__ANDROID_API__=$API -Os -fPIC -DANDROID "\

# ######################################################
#aarch64 不需要 --cpu , 如果是其他cpu请添加下面这句
#--cpu=$PLATFORM \
# #####################################################

echo "开始编译ffmpeg..."
./configure \
--prefix=$PREFIX \
--cc=$TOOLCHAIN/$TARGET$API-clang \
--cxx=$TOOLCHAIN/$TARGET$API-clang++ \
--ld=$TOOLCHAIN/$TARGET$API-clang \
--target-os=android  \
--arch=$ARCH \
--cross-prefix=$TOOLCHAIN/$ARCH-linux-android- \
--disable-asm \
--enable-cross-compile \
--disable-shared \
--disable-doc \
--enable-runtime-cpudetect \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-decoders \
--disable-encoders \
--disable-devices \
--sysroot=$SYSROOT \
--extra-cflags="$CFLAG" \
--extra-ldflags=""
echo "完成编译..."
}
# 调用构建函数。
build2
