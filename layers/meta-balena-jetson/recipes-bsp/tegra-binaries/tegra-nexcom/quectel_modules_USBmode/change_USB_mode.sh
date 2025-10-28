#!/bin/bash

# if the user is not root, there is not point in going forward
THISUSER=`whoami`
if [ "${THISUSER}" != "root" ]; then
        echo "This script requires root privilege"
        exit 1
fi

_AT_PORT=""
SET_MODE=""
WAIT_TIME=200
AT_PORT="/dev/%s"

FUN_PASS=0
FUN_FAIL=1

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

Help(){
	if [ "$#" -ne 1 ] || ! [[ "$1" =~ ^[0|2]$ ]]; then
		echo -e "${RED}[Warning] This script Only support RM520N-GL,EM05-G Module.[Warning]${NC}"
		echo -e "${YELLOW}Help    : ./change_USB_mode.sh argv[1]${NC}";
 		echo -e "${YELLOW}argv[1] : set usbnet mode to 0 or 2.${NC}";
        	echo -e "${YELLOW}argv[1] = 0, load qmi_wwan driver.${NC}"
        	echo -e "${YELLOW}argv[1] = 2, load cdc_mbim driver.${NC}"
		echo -e "${YELLOW}e.g. ./change_USB_mode.sh 0${NC}"
		exit
	fi
	return $FUN_PASS

}
Get_AT_Port(){
	echo -e "${BLUE}Get LTE AT Port...${NC}"
	MODEM="`mmcli -L | grep "No modems were found"`"
	if [ $? -eq $FUN_PASS ]; then
		echo -e "${RED}Can't detect any LTE modem!!${NC}"
		return $FUN_FAIL
	fi
	MODEM="`mmcli -L | awk -F "/Modem/" '{print $2}' | awk -F " " '{print $1}'`"
	_AT_PORT="`mmcli -m $MODEM | grep -oP 'ttyUSB\d+ \(at\)' | head -n 1 | awk '{print $1}'`"
	AT_PORT="`printf $AT_PORT ${_AT_PORT}`"
	if [ "$AT_PORT" != "" ]; then
		echo -e "${GREEN}Get LTE AT Port success!${NC}"
		case $1 in
			"0") SET_MODE="AT+QCFG="\""usbnet"\"",0\r";;
			"2") SET_MODE="AT+QCFG="\""usbnet"\"",2\r";;
		esac
	else
		echo -e "${RED}Can't get LTE AT Port!!${NC}"
		return $FUN_FAIL
	fi
	return $FUN_PASS
}

Set_Mode(){	
	echo -e  "${BLUE}Start set usbnet to mode $1${NC}"
	AT_CMD="`echo -e $SET_MODE | busybox microcom -t $WAIT_TIME $AT_PORT | tr -d '\n\r'`"
	if [ "$AT_CMD" == "OK" ]; then
		echo -e  "${YELLOW}Starting reboot modem...${NC}"
        	AT_CMD="`echo -e 'AT+CFUN=1,1\r' | busybox microcom -t $WAIT_TIME $AT_PORT | tr -d '\n\r'`"
        	if [ "$AT_CMD" == "OK" ]; then
			echo -e "${GREEN}Set Modem reset pass!${NC}"
           		echo -e "${YELLOW}LTE Modem rebooting, wait 30 seconds.${NC}"
        	else
			echo -e "${RED}[Warning] This script Only support RM520N-GL,EM05-G Module.[Warning]${NC}"
			echo -e "${RED}Set usbnet to mode $1 failed!${NC}"
			return $FUN_FAIL
        	fi
	else
		echo -e "${RED}[Warning] This script Only support RM520N-GL,EM05-G Module.[Warning]${NC}"
		echo -e "${RED}Set usbnet to mode $1 failed!${NC}"
		return $FUN_FAIL
	fi
	return $FUN_PASS
}

Help "$@"
Get_AT_Port "$@"
if [ "$?" -eq "$FUN_PASS" ]; then
	Set_Mode "$@"
fi
