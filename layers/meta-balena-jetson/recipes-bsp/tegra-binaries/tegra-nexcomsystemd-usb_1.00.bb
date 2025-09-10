LICENSE = "CLOSED"

inherit systemd

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "usb_power.service"

SRC_URI:append = " file://usb_power.service \
"

S = "${WORKDIR}"

FILES:${PN} += "${systemd_unitdir}/system/usb_power.service"

do_install:append() {
  install -d ${D}/${systemd_unitdir}/system
  install -m 0644 ${WORKDIR}/usb_power.service ${D}/${systemd_unitdir}/system
}

RDEPENDS:${PN} = "bash"

# Only install for Nexcom ATC3750 variants
COMPATIBLE_MACHINE = "nexcom-atc3750-8m-agx-orin-32gb|nexcom-atc3750-8m-agx-orin-64gb"