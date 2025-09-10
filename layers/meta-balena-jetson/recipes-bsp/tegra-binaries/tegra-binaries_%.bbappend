FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Apply ATC3750-specific bootloader patches for Nexcom hardware
SRC_URI:append:nexcom-atc3750-8m-agx-orin-32gb = " \
    file://0001-custom-disable-ramcode-and-not-read-cvb-i2c.patch \
    file://0001-bootloader-add-atc3750-6c-pinmux-and-gpio.patch \
"

SRC_URI:append:nexcom-atc3750-8m-agx-orin-64gb = " \
    file://0001-custom-disable-ramcode-and-not-read-cvb-i2c.patch \
    file://0001-bootloader-add-atc3750-6c-pinmux-and-gpio.patch \
"

do_install() {
    install -m 0644 ${S}/bootloader/*.dts* ${D}${datadir}/tegraflash/
}