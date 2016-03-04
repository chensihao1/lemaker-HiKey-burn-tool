#!/bin/bash

NAME="yaolan123"

for ((i=0; i<${#NAME}; i++)) 
do
	m=${NAME:$i:1 }

	echo $m	
	if [[ "$m" =~ "[0-9]" ]]
	then
		exit
	fi
done
