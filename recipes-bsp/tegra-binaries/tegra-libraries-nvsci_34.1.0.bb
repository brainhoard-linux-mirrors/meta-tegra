L4T_DEB_COPYRIGHT_MD5 = "be0f880db84ffdaaf7c3ca9244ea0f14"
DEPENDS = "tegra-libraries-core"

require tegra-debian-libraries-common.inc

LICENSE += "& MIT"
LIC_FILES_CHKSUM += "file://usr/share/doc/nvidia-tegra/LICENSE.libnvscibuf;md5=0cd5a346aecd6451e0224bf024e84756"

MAINSUM = "00428931252798b5691ba4bbf73c517fedb951062302b4994f4dcbd62cb2c49b"

TEGRA_LIBRARIES_TO_INSTALL = "\
    tegra/libnvscibuf.so.1 \
    tegra/libnvscicommon.so.1 \
    tegra/libnvscievent.so \
    tegra/libnvscistream.so.1 \
    tegra/libnvscisync.so.1 \
"
do_install() {
    install_libraries
    for libname in nvscibuf nvscicommon nvscistream nvscisync; do
	ln -sf lib$libname.so.1 ${D}${libdir}/lib$libname.so
    done
}

FILES_SOLIBSDEV = ""
SOLIBS = ".so*"
RRECOMMENDS:${PN} = "kernel-module-nvgpu"