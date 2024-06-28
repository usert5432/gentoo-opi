EAPI=8

DESCRIPTION="A boot loader for Embedded boards based on PowerPC, ARM, MIPS and
several other processors."
HOMEPAGE="https://github.com/orangepi-xunlong/u-boot-orangepi"

# branch: v2021.07-sunxi
# https://github.com/orangepi-xunlong/u-boot-orangepi/tree/v2021.07-sunxi
COMMIT_UBOOT="6fe17fac388aad17490cf386578b7532975e567f"
COMMIT_OPI="55155f1d73cca3cf6bf42a03d7d16df2b14e8014"

SRC_URI="
	https://github.com/orangepi-xunlong/u-boot-orangepi/archive/${COMMIT_UBOOT}.tar.gz -> u-boot-orangepi-${COMMIT_UBOOT}.tar.gz
	https://github.com/orangepi-xunlong/orangepi-build/archive/${COMMIT_OPI}.tar.gz -> orangepi-build-${COMMIT_OPI}.tar.gz
"

S="${WORKDIR}/u-boot-orangepi-${COMMIT_UBOOT}"

LICENSE="BSD-3 GPL-2"
SLOT="0"
KEYWORDS="~aarch64 ~arm"
IUSE="lowmem"
RESTRICT="strip"

#
# NOTE: these deps are guesstimates
#

RDEPEND="
	app-alternatives/bc
	dev-build/make
	dev-python/setuptools
	=sys-firmware/atf-opi-zero3-20240207
	dev-lang/perl
	dev-build/make
	sys-devel/bison
	sys-devel/flex
	>=sys-libs/ncurses-5.2
	virtual/libelf
	virtual/pkgconfig
"

DEPEND=""
BDEPEND=""

PATCHES=(
	"${FILESDIR}"/${P}_setuptools_version_fix.patch
	"${FILESDIR}"/${P}_fix_ldflags.patch
)

# Source: "external/config/sources/families/sun50iw9.conf"
BOOTDELAY=1
BOOTCONFIG="orangepi_zero3_defconfig"

patch_config() {
	# C.f. orangepi-build:scripts/compilation.sh:compile_uboot
	#
	# The code in this block is licensed after GPL-2
	# copyright belongs to the developers of
	# https://github.com/orangepi-xunlong/orangepi-build/
	#

	sed -i 's/CONFIG_LOCALVERSION=""/CONFIG_LOCALVERSION="-orangepi"/g' .config
	sed -i 's/CONFIG_LOCALVERSION_AUTO=.*/# CONFIG_LOCALVERSION_AUTO is not set/g' .config

	if use lowmem
	then
		sed -i 's/^.*CONFIG_DRAM_SUN50I_H616_TRIM_SIZE*/CONFIG_DRAM_SUN50I_H616_TRIM_SIZE=y/g' .config
	else
		sed -i 's/^.*CONFIG_DRAM_SUN50I_H616_TRIM_SIZE*/# CONFIG_DRAM_SUN50I_H616_TRIM_SIZE is not set/g' .config
	fi

	sed -i "s/^CONFIG_BOOTDELAY=.*/CONFIG_BOOTDELAY=${BOOTDELAY}/" .config \
		|| echo "CONFIG_BOOTDELAY=${BOOTDELAY}" >> .config
}

src_prepare() {
	cp "${EPREFIX}/usr/share/atf-opi-zero3/bl31.bin" . || die
	default
}

src_compile() {
	emake "${BOOTCONFIG}"
	patch_config
}

src_install() {
	dodir /usr/src
	cp -R "${S}" "${ED}/usr/src/${P}" || die

	cat <<-EOF > "${P}"
CONFIG_PROTECT="${EPREFIX}/usr/src/${P}/.config"
EOF
	doenvd "${P}"
}

pkg_postinst() {
	elog "u-boot sources have been installed to '${EPREFIX}/usr/src/${P}'"
	elog "  u-boot can be compiled same way as a linux kernel"
	elog "  feel free to run 'make menuconfig' in the u-boot source dir"
	elog "  to explore configuration parameters."

	elog "Details about u-boot compilation for sunxi platform can be found in"
	elog "  'board/sunxi/README.sunxi64'"
	elog "  see also 'README' file for general information about u-boot."

	elog "When compilation is done, u-boot spl is saved as 'u-boot-sunxi-with-spl.bin'"
	elog "  It can be flashed to an sd card with"
	elog "  $ dd if=u-boot-sunxi-with-spl.bin of=/dev/sdx bs=8k seek=1"

	if use lowmem
	then
		ewarn "u-boot has been configured for low memory devices (<4.0 GB)"
	else
		ewarn "u-boot has been configured for high memory devices (>=4.0 GB)"
	fi

	ewarn "  modify CONFIG_DRAM_SUN50I_H616_TRIM_SIZE .config param to change that"
}

