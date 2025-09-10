SUMMARY = "Nexcom Directory, userapp and userdata"
DESCRIPTION = "nexcom-dir"
LICENSE = "CLOSED"

SRC_URI = "file://image_version	\
	file://MUT \
	file://MUT/install \
	file://G-Sensor \
	file://quectel_modules_USBmode \
"

S = "${WORKDIR}"

FILES:${PN} += "/nexcom \
	/nexcom/G-Sensor \
	/nexcom/quectel_modules_USBmode \
	/nexcom/MUT \
	/nexcom/MUT/install \
"

RDEPENDS:${PN} = "bash"
#CONFFILES:${PN} += "${sysconfdir}/image_version"

FLASH_MD5SUM = "816330f2a0aedb998c243aac16e00adb"
SDK_MD5SUM = "c8499bccbe9dc65377c6e78606876442"

do_install() {
  install -d ${D}/nexcom
  install -d ${D}/nexcom/MUT
  install -d ${D}/nexcom/MUT/install
  install -d ${D}/nexcom/G-Sensor
  install -d ${D}/nexcom/quectel_modules_USBmode
  install -m 0644 ${WORKDIR}/image_version ${D}/nexcom

  install -m 0755 ${WORKDIR}/MUT/install/install_mut.sh ${D}/nexcom/MUT/install
  install -m 0644 "${WORKDIR}/MUT/MUT SDK User Manual for Linux.pdf" ${D}/nexcom/MUT/
  install -m 0755 ${WORKDIR}/MUT/MUT_SDK-linux_v2.2.38.tar.xz.${SDK_MD5SUM} ${D}/nexcom/MUT/
  install -m 0755 ${WORKDIR}/MUT/FLASH_MCU-linux_v2.2.38.tar.xz.${FLASH_MD5SUM} ${D}/nexcom/MUT/

  install -m 0755 ${WORKDIR}/G-Sensor/gsensor ${D}/nexcom/G-Sensor
  install -m 0644 ${WORKDIR}/G-Sensor/gsensor_atc3xxx.c ${D}/nexcom/G-Sensor
  install -m 0755 ${WORKDIR}/quectel_modules_USBmode/change_USB_mode.sh ${D}/nexcom/quectel_modules_USBmode
}

# Only install for Nexcom ATC3750 variants
COMPATIBLE_MACHINE = "nexcom-atc3750-8m-agx-orin-32gb|nexcom-atc3750-8m-agx-orin-64gb"