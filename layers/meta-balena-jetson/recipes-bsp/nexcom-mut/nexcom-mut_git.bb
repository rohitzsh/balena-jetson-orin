# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

# Unable to find any files that looked like license statements. Check the accompanying
# documentation and source headers and set LICENSE and LIC_FILES_CHKSUM accordingly.
#
# NOTE: LICENSE is being set to "CLOSED" to allow you to at least start building - if
# this is not accurate with respect to the licensing of the software being built (it
# will not be in most cases) you must specify the correct value before using this
# recipe for anything other than initial testing/development!
LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

#SRC_URI = "git://10.14.1.226:9443/Leo/mut.git;protocol=https;branch=jetson_aarch"
SRC_URI = "git://10.14.1.226:9443/nvidia/jetson_yocto/scarthgap_jetpack6.1/mut.git;protocol=https;branch=main"

# Modify these as desired
PV = "1.0+git"
#SRCREV = "8430e1aeae1a23613c0b2a7b8a6ac14bf69e9044"
SRCREV = "21d138d707efc4cfe006a6b96e72061a0dd8147b"

S = "${WORKDIR}/git"
B = "${S}"

CC = "aarch64-oe4t-linux-gcc"

DEPENDS += "glibc"

VERSION = "2.2.52"
SDK_PATH = "${B}/linux/demo"
RELEASE_PATH = "${B}/linux/releases"
SDK = "MUT_SDK-linux_v${VERSION}"
FLASH_TOOL = "FLASH_MCU-linux_v${VERSION}"

#EXTRA_OEMAKE += "CFLAGS='-I ${STAGING_DIR_TARGET}/usr/include'"
EXTRA_OEMAKE += "CFLAGS+='--sysroot=${STAGING_DIR_TARGET}'"
EXTRA_OEMAKE += "LDFLAGS+='--sysroot=${STAGING_DIR_TARGET}'"
#EXTRA_OEMAKE += "PYLIB=${libdir}/python3.12/dist-packages"
#CFLAGS += -I${STAGING_DIR_TARGET}/usr/include/python3.8

#LINKFLAGS = "-L${TOOLCHAIN_OPTIONS}"

# NOTE: no Makefile found, unable to determine what needs to be done

do_configure () {
	# Specify any needed configure commands here
	:
}

do_compile () {
	# Specify compilation commands here
	:
	oe_runmake -C ./linux/demo/library service-library-SO
	oe_runmake -C ./linux/demo/library clean-SO
	oe_runmake -C ./linux/demo/library client-library-SO
	oe_runmake -C ./linux/demo/library clean-SO
	oe_runmake -C ./linux/demo/library service-library-A
	oe_runmake -C ./linux/demo/library client-library-A
	oe_runmake -C ./linux/demo/library clean-A

	oe_runmake -C ./linux/demo/service service-A
	oe_runmake -C ./linux/demo/service mcu_ap-A
	oe_runmake -C ./linux/demo/service mcu_menu_ap-A
	oe_runmake -C ./linux/demo/service mcu_upd-M
	oe_runmake -C ./linux/demo/service clean

	oe_runmake -C ./linux/demo/client client
	oe_runmake -C ./linux/demo/client clean
#
}

do_install () {
	# Specify install commands here
	:
	
	# MUT SDK
	if [ ! -d ${RELEASE_PATH}/${SDK} ]; then
		mkdir ${RELEASE_PATH}/${SDK}
	fi

	bbnote "====================================================================================="	
	bbnote "debug message : SDK FOLDER NAME = ${SDK}"
	bbnote "====================================================================================="	

	# release note
	cp -f ${SDK_PATH}/releases ${RELEASE_PATH}/${SDK}

	# client
	cp -rf ${SDK_PATH}/client ${RELEASE_PATH}/${SDK}
        rm -f ${RELEASE_PATH}/${SDK}/client/Makefile_S
        rm -f ${RELEASE_PATH}/${SDK}/client/demoAP.py.ori
        rm -f ${RELEASE_PATH}/${SDK}/client/demoCAN_AP.py
	rm -f ${RELEASE_PATH}/${SDK}/client/src/demoCAN_AP.c
	rm -f ${RELEASE_PATH}/${SDK}/client/src/demoCAN_NXP_AP.c
	rm -f ${RELEASE_PATH}/${SDK}/client/src/demoCAN_ST_AP.c
	rm -f ${RELEASE_PATH}/${SDK}/client/src/demoG_sensor_AP.c
	rm -f ${RELEASE_PATH}/${SDK}/client/src/demoMCU_AP_2.c
	rm -f ${RELEASE_PATH}/${SDK}/client/src/demoMCU_AP-orig.c
	rm -f ${RELEASE_PATH}/${SDK}/client/src/demoMDI_AP.c
	rm -f ${RELEASE_PATH}/${SDK}/client/src/demoMenu_AP.c
	rm -f ${RELEASE_PATH}/${SDK}/client/src/demoPowerButton.c
	rm -f ${RELEASE_PATH}/${SDK}/client/src/demoSetWatchDog_AP.c
	rm -f ${RELEASE_PATH}/${SDK}/client/src/testdemoG_sensor_AP.c
        cp -rf ${SDK_PATH}/service/configs ${RELEASE_PATH}/${SDK}/client	
	
	# service
	cp -rf ${SDK_PATH}/service ${RELEASE_PATH}/${SDK}
	rm -rf ${RELEASE_PATH}/${SDK}/service/FW
	rm -f  ${RELEASE_PATH}/${SDK}/service/LIB_x86_64/libAP_MENU.a
	rm -rf ${RELEASE_PATH}/${SDK}/service/src/mcu_service.c
	rm -rf ${RELEASE_PATH}/${SDK}/service/src/mcu_update.c
	rm -rf ${RELEASE_PATH}/${SDK}/service/src/mcu_system_cmd.c
	rm -f  ${RELEASE_PATH}/${SDK}/service/bin/mcu_get_NVRAM
	rm -f  ${RELEASE_PATH}/${SDK}/service/bin/mcu_upd
	rm -f  ${RELEASE_PATH}/${SDK}/service/flash_mcu.sh
	rm -f  ${RELEASE_PATH}/${SDK}/service/Makefile_S

	tar -Jcf ${RELEASE_PATH}/${SDK}.tar.xz -C ${RELEASE_PATH}/ ${SDK}
	rm -rf ${RELEASE_PATH}/${SDK}
	MD5SUM=$(md5sum ${RELEASE_PATH}/${SDK}.tar.xz | awk {'print $1'})
	mv ${RELEASE_PATH}/${SDK}.tar.xz ${RELEASE_PATH}/${SDK}.tar.xz.${MD5SUM}
	chmod +x ${RELEASE_PATH}/${SDK}.tar.xz.${MD5SUM}

	# MCU Flash Tool
	if [ ! -d ${RELEASE_PATH}/${FLASH_TOOL} ]; then
                mkdir ${RELEASE_PATH}/${FLASH_TOOL}
        fi	
	
	cp -rf ${SDK_PATH}/service/* ${RELEASE_PATH}/${FLASH_TOOL}
	rm -f  ${RELEASE_PATH}/${FLASH_TOOL}/bin/mcu_ap
	rm -f  ${RELEASE_PATH}/${FLASH_TOOL}/bin/mcu_menu_ap
	rm -f  ${RELEASE_PATH}/${FLASH_TOOL}/bin/mcu_service
	rm -rf ${RELEASE_PATH}/${FLASH_TOOL}/include
	rm -f  ${RELEASE_PATH}/${FLASH_TOOL}/LIB_x86_64/libAP_MENU.a
	rm -f  ${RELEASE_PATH}/${FLASH_TOOL}/LIB_x86_64/libAP_MENU.so
	rm -f  ${RELEASE_PATH}/${FLASH_TOOL}/LIB_x86_64/libMCU.a
	rm -rf ${RELEASE_PATH}/${FLASH_TOOL}/src
	rm -f  ${RELEASE_PATH}/${FLASH_TOOL}/launch.sh
	rm -f  ${RELEASE_PATH}/${FLASH_TOOL}/Makefile
	rm -f  ${RELEASE_PATH}/${FLASH_TOOL}/Makefile_S

	tar -Jcf ${RELEASE_PATH}/${FLASH_TOOL}.tar.xz -C ${RELEASE_PATH}/ ${FLASH_TOOL}
        rm -rf ${RELEASE_PATH}/${FLASH_TOOL}
        MD5SUM=$(md5sum ${RELEASE_PATH}/${FLASH_TOOL}.tar.xz | awk {'print $1'})
        mv ${RELEASE_PATH}/${FLASH_TOOL}.tar.xz ${RELEASE_PATH}/${FLASH_TOOL}.tar.xz.${MD5SUM}
        chmod +x ${RELEASE_PATH}/${FLASH_TOOL}.tar.xz.${MD5SUM}
}

