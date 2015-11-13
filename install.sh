#!/bin/bash

sudo fastboot devices >/dev/null

if [ $? -ne 0 ]
then
	sudo dpkg -i android-tools-fastboot.deb && \
	echo "fastboot install OK"
fi

sudo cp -r $PWD/tools/HiKey.rules $PWD/tools/HiKey.bak.rules &&\
sed -i "s:{shell_path}:$PWD/tools:g" $PWD/tools/HiKey.rules &&\
sudo cp -r $PWD/tools/HiKey.rules /etc/udev/rules.d/ &&\
sudo mv $PWD/tools/HiKey.bak.rules $PWD/tools/HiKey.rules


