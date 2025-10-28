LICENSE = "CLOSED"

inherit systemd

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "nexcom.service"

SRC_URI:append = " file://nexcom.service \
		   file://ledstate.sh \
		   file://phytool \
"

S = "${WORKDIR}"

FILES:${PN} += "${systemd_unitdir}/system/nexcom.service"

do_install:append() {
  install -d ${D}${sysconfdir}/systemd
  install -m 0755 ${S}/ledstate.sh ${D}${sysconfdir}/systemd/
  install -d ${D}${base_bindir}
  install -m 0755 ${S}/phytool ${D}${base_bindir}
  install -d ${D}/${systemd_unitdir}/system
  install -m 0644 ${WORKDIR}/nexcom.service ${D}/${systemd_unitdir}/system
}

RDEPENDS:${PN} = "bash"

# Only install for Nexcom ATC3750 variants (both 8M and 6C)
COMPATIBLE_MACHINE = "nexcom-atc3750-8m-agx-orin-32gb|nexcom-atc3750-8m-agx-orin-64gb|nexcom-atc3750-6c-agx-orin-32gb|nexcom-atc3750-6c-agx-orin-64gb"