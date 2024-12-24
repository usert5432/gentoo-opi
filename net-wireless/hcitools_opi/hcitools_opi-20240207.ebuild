EAPI=8

DESCRIPTION="hcitools with OrangePi chipset support"
HOMEPAGE="https://github.com/orangepi-xunlong/orangepi-build"

COMMIT="55155f1d73cca3cf6bf42a03d7d16df2b14e8014"
SRC_URI="https://github.com/orangepi-xunlong/orangepi-build/archive/${COMMIT}.tar.gz -> orangepi-build-${COMMIT}.tar.gz"

S="${WORKDIR}/orangepi-build-${COMMIT}/external/cache/sources/hcitools"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~aarch64 ~arm"
IUSE="extra-tools"

RDEPEND=""
DEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/hcitools_opi_compilation-fix.patch"
	"${FILESDIR}/hcitools_opi_compilation-missing-includes.patch"
)

src_install() {
	exeinto /usr/bin

	doexe output/hciattach_opi

	if use extra-tools
	then
		doexe output/btmon
		doexe output/hciconfig
		doexe output/hcitool
	fi
}

pkg_postinst() {
	einfo ""
	einfo "To activate bluetooth, run the following command:"
	einfo "$ /usr/bin/hciattach_opi -n -s 1500000 /dev/ttyBT0 sprd"
	einfo ""
}

