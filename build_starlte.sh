#!/bin/zsh

ROOT_DIR=$(pwd)
OUT_DIR=$OUT_DIR_COMMON_BASE
BUILDING_DIR=$OUT_DIR/kernel_obj

JOB_NUMBER=`grep processor /proc/cpuinfo|wc -l`

CROSS_COMPILER=$ROOT_DIR/../../../prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
CC_COMPILER=$ROOT_DIR/../../../prebuilts/clang/host/linux-x86/clang-stable/bin/clang

FUNC_PRINT()
{
	echo ""
	echo "=============================================="
	echo $1
	echo "=============================================="
	echo ""
}

FUNC_COMPILE_KERNEL()
{
	FUNC_PRINT "Start Compiling Kernel"

        source ~/workspace/venv/bin/activate

        rm -rf out/
	make -C $ROOT_DIR O=$BUILDING_DIR ARCH=arm64 exynos9810-starlte_defconfig
	make -C $ROOT_DIR O=$BUILDING_DIR -j$JOB_NUMBER ARCH=arm64 CROSS_COMPILE=$CROSS_COMPILER CC="ccache $CC_COMPILER" HOSTCC=clang || exit -1

	FUNC_PRINT "Finish Compiling Kernel"
}

START_TIME=`date +%s`
FUNC_COMPILE_KERNEL
END_TIME=`date +%s`

let "ELAPSED_TIME=$END_TIME-$START_TIME"
echo "Total compile time is $ELAPSED_TIME seconds"

