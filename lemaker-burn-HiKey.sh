#!/bin/bash

########echo the error information#####################
burn_error()
{
        echo "*****$1****$2 burn is error***********"
	
	sudo fastboot -s usb:$1 oem led1 off 2>/dev/null &&\
	sudo fastboot -s usb:$1 oem led2 off 2>/dev/null &&\
	sudo fastboot -s usb:$1 oem led3 off 2>/dev/null &&\
	sudo fastboot -s usb:$1 oem led4 off 2>/dev/null
        exit 0
}

###########burn image##################################
system=`ls ./images/|grep hikey`
ptable=`ls ./images/|grep ptable`
	
config_file="config.txt"
modify_config()
{
        usb_dev=`cat $config_file|grep $1`
        if [ -n "$usb_dev" ]
        then
                sed -i "s/^$1.*/$1:$2/g" $config_file
        else
                echo "$1:$2">>$config_file
        fi
}
burn_uefi()
{
		modify_config $1 0 && \
		sudo fastboot -s usb:$1 flash ptable $PWD/images/$ptable 2>/dev/null &&\
		modify_config $1 1 || \
		burn_error $1 "ptable" && \
		sudo fastboot -s usb:$1 flash fastboot $PWD/images/fip.bin 2>/dev/null &&\
		modify_config $1 2 || \
		burn_error $1 "fip" && \
		sudo fastboot -s usb:$1 flash nvme $PWD/images/nvme.img 2>/dev/null &&\
		modify_config $1 3 || \
		burn_error $1 "nvme" && \
		sudo fastboot -s usb:$1 flash boot $PWD/images/boot-fat.uefi.img 2>/dev/null &&\
		modify_config $1 4 || \
		burn_error $1 "boot" && \
		sudo fastboot -s usb:$1 flash system $PWD/images/$system 2>/dev/null && \
		modify_config $1 5 || \
		burn_error $1 "system" && \
                sudo fastboot -s usb:$1 oem led2 on 2>/dev/null &&\
                sudo fastboot -s usb:$1 oem led3 on 2>/dev/null &&\
                sudo fastboot -s usb:$1 oem led4 on 2>/dev/null &&\

                echo "#####################################" && \
		echo "    $1  Image burn OK      " &&\
		echo "#####################################"
                exit 0
}

##################create fifo#########################
tmp_fifofile="/tmp/uefi.fifo"
if [ ! -p $tmp_fifofile ]
then
	mkfifo "$tmp_fifofile"
else
	rm $tmp_fifofile
	mkfifo "$tmp_fifofile"
fi

exec 6<>"$tmp_fifofile"

############add rules if not install####################
check_rules=`ls /etc/udev/rules.d`
rules_flag=0
for rules in $check_rules
do
	if [ $rules = "HiKey.rules" ]
	then
		rules_flag=1
		break
	fi
done

if [ $rules_flag -eq 0 ]
then
	$PWD/install.sh
fi
####################start webserver#######################
./webserver &

####################main##################################
x=0
trap 'x=1' SIGINT
while (true)
do
		if [ $x -eq 1 ]
		then
			break;
		fi

        for usb_dev in /dev/ttyUSB*
        do
                if test -e $usb_dev
                then
                        sudo python $PWD/images/hisi-idt.py -d $usb_dev --img1=$PWD/images/l-loader.bin >/dev/null &&\
                        echo "********l-loader burn is ok************"
                fi
        done
	
        sleep 1

        read -t 1 -u6 burn_over
#	echo "******$burn_over*******************"
	if [ -n "$burn_over" ]
	then
		burn_uefi $burn_over &
	fi
	
done

ps -axu | grep webserver |grep -v "grep"| awk '{print $2}'|sudo xargs kill -9
#rm config.txt
#sleep 1
#touch config.txt
