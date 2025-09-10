#!/bin/bash

### Global Variables ###

OFF=0;ON=1;
WAIT_SEC=5

FUN_PASS=0
FUN_FAIL=1

MCU_DEV=""
MCU_DEV_ATC3530="/dev/ttyTHS1"
MCU_DEV_ATC3750="/dev/ttyTHS4"

CONST_AQR113C="eth1"

PRODUCT=$(tr -d '\0' < /proc/device-tree/product)

export DISPLAY=:0

### Global Variables ###

chkProduct() {
	#check product name
	case "$PRODUCT" in
		ATC35*) MCU_DEV=$MCU_DEV_ATC3530
		;;
		ATC3750*) MCU_DEV=$MCU_DEV_ATC3750
		;;
		X80*) 
			MCU_DEV=$MCU_DEV_ATC3530
			PRODUCT="ATC3540"
		;;
	esac
	return $FUN_PASS
}

osState() {
	if [ ! -e $MCU_DEV ]; then
		exit -1
	else
		/bin/stty -F $MCU_DEV 115200 raw -echo -echoe -echok
	fi
	sleep $WAIT_SEC
	#turn on OS status LED 
	echo -e "\xF1\xE0\x03\x14\x02\x1E\xF2" > $MCU_DEV

	return $FUN_PASS
}

# disable all ethernet eee function
disable_eth_eee() {
	for ETH in `find /sys/devices/platform/ -name "eth*" | awk -F/ '{print $NF}'`
	do
		if [ "$ETH" == "eth0" -a "$PRODUCT" == "ATC3750" ]; then # ignore KSZ9477 set eee off
			continue;
		fi
        	ethtool --set-eee $ETH eee off
		ethtool -s $ETH wol d
	done	            
	return $FUN_PASS
}

BT() {
    #BT off
    echo -e "\xf1\x00\x03\x17\x00\x30\xf2" > $MCU_DEV
    sleep 1
    #BT on
    echo -e "\xf1\x00\x03\x17\x01\x6A\xf2" > $MCU_DEV
	return $FUN_PASS
}

chkGPS() {
    #2 ports POE version only: ATC3530-IP7-4MP
    stty -F "/dev/ttyACM0"
    if [ $? -eq $FUN_PASS ]; then
            sleep 0.1
            echo -e "\xF1\xE0\x03\x18\x01\x70\xF2" > $MCU_DEV
    else
            sleep 0.1
            echo -e "\xF1\xE0\x03\x18\x00\x2A\xF2" > $MCU_DEV
    fi
	return $FUN_PASS
}

USB() {
	# USB on
	if [ "$1" == "$ON" ]; then
		echo -e "\xF1\x00\x03\x19\x01\x1C\xF2" > $MCU_DEV
	elif [ "$1" == "$OFF" ]; then
		if [ "$PRODUCT" == "ATC3750" ]; then 
			echo -e "\xF1\x00\x03\x19\x05\x2E\xF2" > $MCU_DEV
		elif [ "$PRODUCT" == "ATC3750-8M" ]; then
			echo -e "\xF1\x00\x03\x19\x00\x46\xF2" > $MCU_DEV
		fi
	fi
	return $FUN_PASS
}

MCU_service(){
        MCU_SERVICE="`whereis mcu_service | awk -F : '{print $NF}'`"
        if [ -d /etc/configs ] && [ "${MCU_SERVICE}" != "" ]; then
        #if [ -d /etc/configs ]; then
                export LD_LIBRARY_PATH=/lib/LIB_x86_64
                cd /etc; mcu_service &
        fi

}

aqr113c_setting() {
	#set 10G eth LED register
        /usr/bin/phytool write ${CONST_AQR113C}/0:30/0xc430 0xc0ef
        /usr/bin/phytool write ${CONST_AQR113C}/0:30/0xc431 0x0080
        /usr/bin/phytool write ${CONST_AQR113C}/0:30/0xc432 0xc040
}

#Setting ISP and VI clock to maximum and locking it
max_isp_vi_clks() {
	MAX_VI_RATE=$(cat /sys/kernel/debug/bpmp/debug/clk/vi/max_rate)
	MAX_ISP_RATE=$(cat /sys/kernel/debug/bpmp/debug/clk/isp/max_rate)
	MAX_NVCSI_RATE=$(cat /sys/kernel/debug/bpmp/debug/clk/nvcsi/max_rate)
	MAX_VIC_RATE=$(cat /sys/kernel/debug/bpmp/debug/clk/vic/max_rate)
	MAX_EMC_RATE=$(cat /sys/kernel/debug/bpmp/debug/clk/emc/max_rate)

	echo $MAX_VI_RATE > /sys/kernel/debug/bpmp/debug/clk/vi/rate
	echo $MAX_ISP_RATE > /sys/kernel/debug/bpmp/debug/clk/isp/rate
	echo $MAX_NVCSI_RATE > /sys/kernel/debug/bpmp/debug/clk/nvcsi/rate
	echo $MAX_VIC_RATE > /sys/kernel/debug/bpmp/debug/clk/vic/rate
	echo $MAX_EMC_RATE > /sys/kernel/debug/bpmp/debug/clk/emc/rate

	echo 1 > /sys/kernel/debug/bpmp/debug/clk/vi/mrq_rate_locked
	echo 1 > /sys/kernel/debug/bpmp/debug/clk/isp/mrq_rate_locked
	echo 1 > /sys/kernel/debug/bpmp/debug/clk/nvcsi/mrq_rate_locked
	echo 1 > /sys/kernel/debug/bpmp/debug/clk/vic/mrq_rate_locked
	echo 1 > /sys/kernel/debug/bpmp/debug/clk/emc/mrq_rate_locked

}

case "$1" in
        "boot")
		chkProduct
		osState			
		disable_eth_eee
		MCU_service
		case "$PRODUCT" in
			ATC35*)	# ATC3520 / 3530 / 3540
				BT
				chkGPS
				sleep 5
				modprobe -i ap_m12mo_vbo
			;;
				
			"ATC3750")
				USB $ON
				aqr113c_setting
			;;
				
			"ATC3750-8M")
				USB $ON
				if [[ "`nvpmodel -q | grep -oP MAXN`" == "MAXN" ]]; then
					max_isp_vi_clks	
				fi
			;;
		esac          
        ;;
        "resume")
        	if [[ $PRODUCT =~ ^ATC35 ]]; then	# ATC3520 / 3530 / 3540
			osState
		fi
	;;
	"usb-resume")
                chkProduct
                if [[ $PRODUCT =~ ^ATC375 ]]; then
                        USB $OFF
                fi
        ;;
esac

while [ "`xrandr | grep "DP-0 disconnected"`" != "" ];
do
        sleep 1
done

xrandr --output DP-0 --auto
