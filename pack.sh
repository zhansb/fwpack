#!/bin/bash
# pack.sh pack_name

set -e
. build/envsetup.sh >/dev/null && setpaths


ANDROID_ROOT="$(get_abs_build_var)"
TARGET_PRODUCT=`get_build_var TARGET_PRODUCT`
PLATFORM_VERSION=`get_build_var PLATFORM_VERSION`
IMAGE_PATH="$ANDROID_ROOT/rockdev/Image-$TARGET_PRODUCT"
PACK_PATH="$(dirname $(readlink -f $0))"
BOARD_PATH="$PACK_PATH/$TARGET_PRODUCT"
BIN_DIR="$PACK_PATH/bin/"

check_file_version()
{
    # $1 file name
	if [ ! -e $BOARD_PATH/$1.$PLATFORM_VERSION ] ; then
		echo "Not exist $1.$PLATFORM_VERSION"
		exit 1
	fi
}

if [ z"$1" != "z" ] ; then
	UPDATE_IMG="$1"
else
	UPDATE_IMG="Firefly-RK3288_$(date -d today +%y%m%d).img" 
fi

check_file_version "parameter"
check_file_version "RKLoader.bin"

cp $BOARD_PATH/package-file $IMAGE_PATH
cp $BOARD_PATH/recover-script $IMAGE_PATH
cp $BOARD_PATH/update-script $IMAGE_PATH
cp $BOARD_PATH/parameter.$PLATFORM_VERSION $IMAGE_PATH/parameter
cp $BOARD_PATH/RKLoader.bin.$PLATFORM_VERSION $IMAGE_PATH/RKLoader.bin

pushd "$IMAGE_PATH" > /dev/null

#CHECK_FILE_EXISTS "package-file"
$BIN_DIR/afptool -pack ./ update_tmp.img
$BIN_DIR/rkImageMaker -${OPT_IMG_MAKER_CHIP_TYPE:-RK32} RKLoader.bin update_tmp.img $UPDATE_IMG -os_type:androidos
rm update_tmp.img

popd > /dev/null


echo -e "\nTARGET: ${IMAGE_PATH}/${UPDATE_IMG}"
