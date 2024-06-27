EAPI=8

DESCRIPTION="Trusted Firmware-A (TF-A) is a reference implementation of secure
world software for Arm A-Profile architectures (Armv8-A and Armv7-A)"
HOMEPAGE="https://github.com/ARM-software/arm-trusted-firmware"

COMMIT="4da4a1a61d84ad5c1cddbd9b90373654c615982a"
COMMIT_OPI="55155f1d73cca3cf6bf42a03d7d16df2b14e8014"

SRC_URI="
	https://github.com/ARM-software/arm-trusted-firmware/archive/${COMMIT}.tar.gz -> atf-${PV}.tar.gz
	https://github.com/orangepi-xunlong/orangepi-build/archive/${COMMIT_OPI}.tar.gz -> orangepi-build-${COMMIT_OPI}.tar.gz
"

S="${WORKDIR}/arm-trusted-firmware-${COMMIT}"

LICENSE="BSD-3 GPL-2"
SLOT="0"
KEYWORDS="~aarch64 ~arm"
IUSE=""

RDEPEND=""
DEPEND="${DEPEND}"
BDEPEND=""

DOCS=(
	"readme.rst"
	"docs/license.rst"
)

# Source: "external/config/sources/families/sun50iw9.conf"

MAKE_ARGS=(
	"PLAT=sun50i_h616" "DEBUG=1" "bl31"
)
TARGET_FILES=(
	"build/sun50i_h616/debug/bl31.bin"
	"docs/license.rst"
)

src_prepare() {
	default

	local patchdir="${WORKDIR}/orangepi-build-${COMMIT_OPI}"
	patchdir="${patchdir}/external/patch/atf/atf-sunxi64"

	for patch in "${patchdir}"/*.patch
	do
		eapply "${patch}"
	done
}

src_compile() {
	emake ENABLE_BACKTRACE="0" LDFLAGS= "${MAKE_ARGS[@]}"
}

src_install() {
	insinto "/usr/share/${PN}"

	for path in "${TARGET_FILES[@]}"
	do
		doins "${path}"
	done

	einstalldocs
}

