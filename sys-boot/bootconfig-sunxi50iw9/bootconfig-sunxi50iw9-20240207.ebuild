EAPI=8

COMMIT_OPI="55155f1d73cca3cf6bf42a03d7d16df2b14e8014"

DESCRIPTION="OrangePi Kernel Sources"
HOMEPAGE="https://github.com/orangepi-xunlong/linux-orangepi"
SRC_URI="
	https://github.com/orangepi-xunlong/orangepi-build/archive/${COMMIT_OPI}.tar.gz -> orangepi-build-${COMMIT_OPI}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm arm64"
IUSE=""

PATCHES=()
S="${WORKDIR}/orangepi-build-${COMMIT_OPI}/external"

src_compile() {
	echo "overlay_prefix=sun50i-h616" >> "config/bootenv/sun50iw9-default.txt"
	echo "rootdev=UUID=XXXX"          >> "config/bootenv/sun50iw9-default.txt"
	echo "rootfstype=ext4"            >> "config/bootenv/sun50iw9-default.txt"
}

pkg_postinst() {
	einfo ""
	einfo "Orangepi boot files have been installed to '/usr/share/${PN}' ."
	einfo "You will need to copy them to /boot manually."
	einfo ""
	einfo "The /boot/orangepiEnv.txt will need to be manually adjusted."
	einfo "In particular, make sure to set proper a 'rootdevice'."
	einfo ""
	einfo "After installing, the bootscript needs to be compiled by running"
	einfo "$ mkimage -C none -A arm -T script -d /boot/boot.cmd /boot/boot.scr"
	einfo ""
	einfo "Make sure that the initramfs is packed into uboot format as well"
	einfo "$ mkimage -C none -A arm -T ramdisk -d raw_ramdisk uboot_ramdisk"
	einfo ""
	einfo "Orangepi bootscript expects the kernel, ramdisk, and dtb to be "
	einfo "available by the following paths:"
	einfo "  - kernel : /boot/Image"
	einfo "  - ramdisk: /boot/uInitrd"
	einfo "  - dtb    : /boot/dtb"
	einfo "make sure to create the appropriate symlinks."
	einfo ""
}

src_install() {
	insinto "/usr/share/${PN}"

	newins "config/bootscripts/boot-sun50iw9-next.cmd" "boot.cmd"
	newins "config/bootenv/sun50iw9-default.txt" "orangepiEnv.txt"

	newins "packages/blobs/splash/orangepi-u-boot.bmp" "boot.bmp"
	newins "packages/blobs/splash/logo.bmp" "logo.bmp"
}

