# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib-minimal

DESCRIPTION="An library to provide useful functions commonly found on BSD systems"
HOMEPAGE="https://libbsd.freedesktop.org/wiki/"
SRC_URI="https://${PN}.freedesktop.org/releases/${P}.tar.xz"

LICENSE="BSD BSD-2 BSD-4 ISC"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~mips ppc x86"
IUSE="static-libs"

DEPEND=">=sys-kernel/linux-headers-3.17"
RDEPEND=""

PATCHES=( "${FILESDIR}/${P}-missing-fcntl_h.patch" )

pkg_setup() {
	local f="${EROOT}/usr/$(get_libdir)/${PN}.a"
	local m="You need to remove ${f} by hand or re-emerge sys-libs/glibc first."
	if ! has_version ${CATEGORY}/${PN}; then
		if [[ -e ${f} ]]; then
			eerror "${m}"
			die "${m}"
		fi
	fi
}

multilib_src_configure() {
	# The build system will install libbsd-ctor.a despite of USE="-static-libs"
	# which is correct, see:
	# https://cgit.freedesktop.org/libbsd/commit/?id=c5b959028734ca2281250c85773d9b5e1d259bc8
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	find "${ED}" -name "*.la" -delete || die
}
