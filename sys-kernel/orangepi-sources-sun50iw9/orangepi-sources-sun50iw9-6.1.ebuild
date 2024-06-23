EAPI=8

ETYPE="sources"
MY_P="orange-pi-6.1-sun50iw9"

K_DEFCONFIG="linux-6.1-sun50iw9-next"
K_SECURITY_UNSUPPORTED="1"
K_WANT_GENPATCHES=""

KV_FULL="${PV}-sun50iw9"

inherit kernel-2

COMMIT_OPI="55155f1d73cca3cf6bf42a03d7d16df2b14e8014"

DESCRIPTION="OrangePi Kernel Sources"
HOMEPAGE="https://github.com/orangepi-xunlong/linux-orangepi"
SRC_URI="
	https://github.com/orangepi-xunlong/linux-orangepi/archive/${MY_P}.tar.gz
	defconfig? ( https://github.com/orangepi-xunlong/orangepi-build/archive/${COMMIT_OPI}.tar.gz -> orangepi-build-${COMMIT_OPI}.tar.gz )
"

DEPEND="${DEPEND}
	dev-embedded/u-boot-tools
"

KEYWORDS="~aarch64 ~arm"
IUSE="+defconfig"

PATCHES=()
S="${WORKDIR}/linux-${KV_FULL}"


pkg_setup() {
	ewarn ""
	ewarn "'defconfig' use flag install the default kernel configuration file"
	ewarn "used by the orangepi-build compilation scripts."
	ewarn ""
	ewarn "Alternatively, one can start with 'make linux_sunxi64_defconfig'"
	ewarn "as a suggested config file for orangepi."
	ewarn ""
	ewarn "Note, orangepi sources do not track module dependencies"
	ewarn "correctly. Thus, one may run into linking errors when some of the "
	ewarn "required module dependencies are not selected."
	ewarn ""

	kernel-2_pkg_setup
}

universal_unpack() {
	unpack "${MY_P}.tar.gz"
	mv "${WORKDIR}/linux-orangepi-${MY_P}" "${WORKDIR}/linux-${KV_FULL}" || die

	if use defconfig
	then
		unpack "orangepi-build-${COMMIT_OPI}.tar.gz" || die

		local root="${WORKDIR}/orangepi-build-${COMMIT_OPI}"
		cp \
			"${root}/external/config/kernel/linux-6.1-sun50iw9-next.config" \
			"${WORKDIR}/linux-${KV_FULL}/.config" \
			|| die
	fi
}

