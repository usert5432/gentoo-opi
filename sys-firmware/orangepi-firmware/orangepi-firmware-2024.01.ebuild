EAPI=8

COMMIT="76ead17a1770459560042a9a7c43fe615bbce5e7"

DESCRIPTION="Orange Pi specific firmware"
HOMEPAGE="https://github.com/orangepi-xunlong/firmware"
SRC_URI="https://github.com/orangepi-xunlong/firmware/archive/${COMMIT}.tar.gz -> ${PN}-${COMMIT}.tar.gz"

S="${WORKDIR}/firmware-${COMMIT}"

LICENSE="unknown"
SLOT="0"
KEYWORDS="~aarch64 ~arm"

RDEPEND=""

src_install() {
	insinto /lib/firmware
	doins -r "${S}"/.
}

