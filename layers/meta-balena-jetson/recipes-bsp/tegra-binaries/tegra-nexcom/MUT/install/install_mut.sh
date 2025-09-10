#!/bin/bash

MUT_VER="2.2.38"
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# if the user is not root, there is not point in going forward
THISUSER=`whoami`
if [ "${THISUSER}" != "root" ]; then
        echo -e "${RED}This script requires root privilege.${NC}"
        exit 1
fi

install()
{

cp ../MUT_SDK-linux_v$MUT_VER.tar.xz.* ../MUT_SDK-linux_v$MUT_VER.tar.xz
tar xvf ../MUT_SDK-linux_v$MUT_VER.tar.xz
cp MUT_SDK-linux_v$MUT_VER/service/bin/mcu_service /usr/bin/
cp MUT_SDK-linux_v$MUT_VER/client/bin/* /usr/bin/
cp -afv MUT_SDK-linux_v$MUT_VER/service/LIB_x86_64 /usr/lib/
cp -afv MUT_SDK-linux_v$MUT_VER/client/LIB_x86_64 /usr/lib/
mkdir /etc/configs
cp -afv MUT_SDK-linux_v$MUT_VER/service/configs/ATC3* /etc/configs

echo -e "${GREEN}Please reboot to activate the setting.${NC}"

}

remove()
{

rm -rfv /etc/configs /etc/usr/lib/LIB_x86_64
rm -rfv /usr/bin/mcu_service /usr/bin/demoMCU_AP /usr/bin/demoCAN_AP

echo -e "${GREEN}removed the LD_LIBRARY_PATH.${NC}"

}

read -p "install/remove MUT(i/r)?" read

if [ "$read" == "i" ]; then
        install
elif [ "$read" == "r" ]; then
        remove
else
        echo -e "${GREEN}do nothing.${GREEN}"
fi

