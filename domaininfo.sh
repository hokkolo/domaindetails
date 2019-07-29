#!/bin/bash

function MENU(){
	echo "1. List the Domain Details"
	echo "2. List Subdomains"
	echo "3. Exit"
        read -p "Enter your choice: " VAL
	case "$VAL" in
		1) echo "Listing the Domain details"
			DOMAINCHECK
			;;
		2) echo "Listing Subdomains"
			SUBDOMAINS
			;;
		3)exit
			;;
	esac

}

function DOMAINCHECK(){

	IP=`dig @8.8.8.8 $DOMAIN +short`
	NS=`dig @8.8.8.8 NS $DOMAIN +short`
	MX=`dig @8.8.8.8 mx $DOMAIN +short`
	PTR=`host -t A $IP`
	if [ $(whois $DOMAIN | grep Expiry | awk '{print $4}') ];then 
		EXP=`whois $DOMAIN | grep Expiry | awk '{print $4}'`
	else 
		EXP="Domain Expiry not found"
	fi
	echo "IP Address: " 
	for i in $IP;do
		echo $i
	done
	echo "Nameservers: " 
	for i in $NS;do
		echo $i
	done
	echo "Mail Servers: " 
	for i in $MX;do
		echo $i
	done
	echo "Host Server: "$PTR
	echo "Domain Expiry: " $EXP
	MENU
}
function SUBDOMAINS(){
	URL=https://api.hackertarget.com/hostsearch/?q=
	SUB=`curl $URL$DOMAIN`
	for i in $SUB; do
		echo $i
	done
	MENU
}


read -p "Enter the domains name: " DOMAIN
if [ $(dig @8.8.8.8 $DOMAIN +short) ];then
	MENU
else
	echo "Domain does not exist in Google Records...!!!!!"
	exit

fi	
