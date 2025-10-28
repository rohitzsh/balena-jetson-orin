FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Apply Nexcom ATC3750 UEFI customization patches for both variants
SRC_URI:append:nexcom-atc3750-8m-agx-orin-32gb = " \
    file://0005-ignore-ethernet-phy-init.patch \
    file://0006-add-nexcom-logo.patch \
"

SRC_URI:append:nexcom-atc3750-8m-agx-orin-64gb = " \
    file://0005-ignore-ethernet-phy-init.patch \
    file://0006-add-nexcom-logo.patch \
"

SRC_URI:append:nexcom-atc3750-6c-agx-orin-32gb = " \
    file://0005-ignore-ethernet-phy-init.patch \
    file://0006-add-nexcom-logo.patch \
"

SRC_URI:append:nexcom-atc3750-6c-agx-orin-64gb = " \
    file://0005-ignore-ethernet-phy-init.patch \
    file://0006-add-nexcom-logo.patch \
"