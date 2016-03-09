#!/bin/bash
# pack.sh pack_name

set -e
. build/envsetup.sh >/dev/null && setpaths


ANDROID_ROOT="$(get_abs_build_var)"
TARGET_PRODUCT=`get_build_var TARGET_PRODUCT`
IMAGE_PATH="$ANDROID_ROOT/rockdev/Image-$TARGET_PRODUCT"
PACK_PATH="$(dirname $(readlink -f $0))"
BIN_DIR="$PACK_PATH/bin/"


if [ z"$1" != "z" ] ; then
	UPDATE_IMG="$1"
else
	UPDATE_IMG="FirePrime_$(date -d today +%y%m%d).img" 
fi

#set -x
cp $PACK_PATH/package-file $IMAGE_PATH
cp $PACK_PATH/parameter $IMAGE_PATH
cp $PACK_PATH/recover-script $IMAGE_PATH
cp $PACK_PATH/RKLoader.bin $IMAGE_PATH
cp $PACK_PATH/update-script $IMAGE_PATH

pushd "$IMAGE_PATH" > /dev/null

#CHECK_FILE_EXISTS "package-file"
$BIN_DIR/afptool -pack ./ update_tmp.img
$BIN_DIR/rkImageMaker -${OPT_IMG_MAKER_CHIP_TYPE:-RK312A} RKLoader.bin update_tmp.img $UPDATE_IMG -os_type:androidos
rm update_tmp.img

popd > /dev/null


echo -e "\nTARGET: ${IMAGE_PATH}/${UPDATE_IMG}"
