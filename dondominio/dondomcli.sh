#!/bin/bash

############################################################
#
#	DONDOMINIO Dynamic IP Client
#
# Fichero de configuración por defecto
#
# @author: Soluciones Corporativas IP (SCIP)
# @email: info@dondominio.com
#
############################################################

DEFAULTCONFIG=/etc/dondominio/dondomcli.conf
APIURL="https://dondns.dondominio.com/plain/"
WGET=`which wget`
WGETOPT=" -q --no-check-certificate -O - --user-agent=WgetDonDNS/1.1 --post-data "
CUT=`which cut`
ECHO=`which echo`


if [ "$WGET" = "" ]; then
	WGET=`which curl`
	WGETOPT="-A CurlDonDNS/1.1 --data"
fi

function CheckWget()
{
	if [ ! -x "$WGET" ]; then
		Usage "wget/curl command not found!!"
	fi
}

function Usage()
{
	echo ""
	echo "============================"
	echo "DonDominio Dynamic IP Client"
	echo "============================"
	if [ ! -z "$1" ]; then
		echo " ERROR: $1"
		echo ""
	fi

	echo "Usage: $0 -u <USER> -p <PASSWORD> -h <HOST> [-i <IP>]"
	echo "Usage: $0 -c <FILECONFIG> [-i <IP>] [-h <HOST>] [-p <PASSWORD>] [-u <USER>]"
	echo ""
	echo "Note:"
	echo " * Default file config is $DEFAULTCONFIG";
	echo " * If not specified the IP address, this is obtained automatically"
	echo ""
	exit 1;
}

DDCONFIG=$DEFAULTCONFIG
DDUSER=""
DDPASSWORD=""
DDIP=""
DDHOST=""

CheckWget;

while getopts ":u:p:h:i:c:" opt 
do
#echo $opt $OPTIND $OPTARG
	case $opt in
		c)
			if [ ! -f $OPTARG ]; then
				Usage "Invalid file config: $OPTARG"
			fi
			DDCONFIG=$OPTARG
			;;
		u)
			myuser=$OPTARG
			;;
		p)
			mypass=$OPTARG
			;;
		i)
			myip=$OPTARG;
			;;
		h)
			myhost=$OPTARG;
			;;
		\?)
			Usage "Invalid argument!";
			;;
	esac 
done
shift $(($OPTIND -1))

if [ -f $DDCONFIG ]; then
	. $DDCONFIG
fi
if [ $myuser ]; then
	DDUSER=$myuser
fi
if [ $mypass ]; then
	DDPASSWORD=$mypass
fi
if [ $myip ]; then
	DDIP=$myip
fi
if [ $myhost ]; then
	DDHOST=$myhost
fi

if [  "$DDUSER" = ""  -o  "$DDPASSWORD" = "" -o "$DDHOST" = "" ]; then
	Usage "Missing data"
fi

i=1
HOST="$($ECHO $DDHOST | $CUT -d , -f $i -s)"

if [ $HOST ]
then
	while [ $HOST ]
	do
		$WGET $WGETOPT "user=$DDUSER&password=$DDPASSWORD&host=$HOST&ip=$DDIP" "$APIURL"
		i=$[$i+1]
		HOST="$($ECHO $DDHOST | $CUT -d , -f $i)"
	done
else
	$WGET $WGETOPT "user=$DDUSER&password=$DDPASSWORD&host=$DDHOST&ip=$DDIP" "$APIURL"
fi

exit 0;
