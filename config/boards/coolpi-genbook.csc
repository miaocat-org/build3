# Rockchip RK3588 SoC octa core 4-16GB SoC eMMC USB3 NVME
BOARD_NAME="CoolPi GenBook"
BOARDFAMILY="rockchip-rk3588"
BOARD_MAINTAINER="andyshrk"
BOARD_FIRMWARE_INSTALL="-full"
BOOT_SOC="rk3588"
BOOTCONFIG="coolpi-cm5-genbook-rk3588_defconfig"
KERNEL_TARGET="edge,vendor"
FULL_DESKTOP="yes"
BOOT_LOGO="desktop"
BOOT_FDT_FILE="rockchip/rk3588-coolpi-cm5-genbook.dtb"
BOOT_SCENARIO="spl-blobs"
BOOT_SUPPORT_SPI="yes"
BOOT_SPI_RKSPI_LOADER="yes"
IMAGE_PARTITION_TABLE="gpt"

# Mainline U-Boot
function post_family_config__coolpi-genbook_use_mainline_uboot() {
	display_alert "$BOARD" "mainline (next branch) u-boot overrides for $BOARD / $BRANCH" "info"

	declare -g BOOTSOURCE="https://github.com/u-boot/u-boot.git" # Mainline U-Boot
	unset BOOTBRANCH
	declare -g BOOTPATCHDIR="v2025.01-rc3-coolpi-cm5"
	declare -g BOOTBRANCH_BOARD="tag:v2025.04"
	declare -g UBOOT_TARGET_MAP="BL31=${RKBIN_DIR}/${BL31_BLOB} ROCKCHIP_TPL=${RKBIN_DIR}/${DDR_BLOB};;u-boot-rockchip.bin u-boot-rockchip-spi.bin"
	unset uboot_custom_postprocess write_uboot_platform write_uboot_platform_mtd # disable stuff from rockchip64_common; we're using binman here which does all the work already

	# Just use the binman-provided u-boot-rockchip.bin, which is ready-to-go
	function write_uboot_platform() {
		dd "if=$1/u-boot-rockchip.bin" "of=$2" bs=32k seek=1 conv=notrunc status=none
	}

	function write_uboot_platform_mtd() {
		flashcp -v -p "$1/u-boot-rockchip-spi.bin" /dev/mtd0
	}
}
