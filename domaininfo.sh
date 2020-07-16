#!/bin/bash
#AUTHOR=Gautham
#VERSION=29072019
#List menu function
#Colourcode
NONE=`tput sgr0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
GREEN=`tput setaf 2`
function MENU(){
	echo "${RED}1. List the Domain Details${NONE}"
	echo "${RED}2. List Subdomains${NONE}"
	echo "${RED}3. Exit${NONE}"
	read -p "${YELLOW}Enter your choice:${NONE} " VAL
	case "$VAL" in
		1) echo "${GREEN}Listing the Domain details${NONE}"
			DOMAINCHECK
			;;
		2) echo "${GREEN}Listing Subdomains${NONE}"
			SUBDOMAINS
			;;
		3)exit
			;;
	esac
}

#Function to list the domain details
function DOMAINCHECK(){

	IP=`dig @8.8.8.8 $DOMAIN +short`
	NS=`dig @8.8.8.8 NS $DOMAIN +short`
	MX=`dig @8.8.8.8 mx $DOMAIN +short`
	PTR=`host -t A $IP`
	if [ $(whois $DOMAIN | grep Expiry | awk '{print $4}') ];then 
		EXP=`whois $DOMAIN | grep Expiry | awk '{print $4}'`
	else 
		EXP="${RED}Domain Expiry not found${NONE}"
	fi
	echo "IP Address: "
        echo "-------------"	
	for i in $IP;do
		echo $i
	done
	 echo "-------------"
	echo "Nameservers: " 
	 echo "-------------"
	for i in $NS;do
		echo $i
	done
	 echo "-------------"
	echo "Mail Servers: "
        echo "-------------"	
	for i in $MX;do
		echo $i
	done
	 echo "-------------"
	echo "Host Server: "$PTR
	 echo "-------------"
	echo "Domain Expiry: " $EXP
	 echo "-------------"
	MENU
}

#Function to list subdomains
function SUBDOMAINS(){
	URL=https://api.hackertarget.com/hostsearch/?q=
	SUB=`curl $URL$DOMAIN`
	for i in $SUB; do
		echo $i
	done
	MENU
}

#Main function
read -p "Enter the domains name: " DOMAIN
if [ $(dig @8.8.8.8 $DOMAIN +short) ];then
	MENU
else
	echo "${RED}Domain does not exist in Google Records...!!!!!${NONE}"
	exit
fi	
