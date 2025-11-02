#!/bin/sh
#

FORMAT="[${0##*/}]"

DIR=`pwd`
GITPULL="git pull"
GITPUSH="git push origin master"
GITSTATUS="git status"
REPLIST="apps cdk driver flash"
SH4GIT=$2

case "$1" in
	clone)
#		if [ "$(whoami)" == "obiaus" ];then
		if [ ! -z "$SH4GIT" ] && [ "$SH4GIT" == "2" ];then
		    echo "$FORMAT -------------------------------------------"
			echo "$FORMAT git clone https://github.com/openaaf/buildsystem"
			git clone https://github.com/openaaf/buildsystem buildsystem-ddt
		else
		    echo "$FORMAT -------------------------------------------"
			echo "$FORMAT git clone https://github.com/openaaf/buildsystem-ddt"
			git clone https://github.com/openaaf/buildsystem-ddt buildsystem-ddt
		fi

	    echo "$FORMAT -------------------------------------------"
		echo "$FORMAT link cdk > buildsystem-ddt"
		ln -s buildsystem-ddt cdk

		cd $DIR/buildsystem-ddt

	    echo "$FORMAT -------------------------------------------"
		echo "$FORMAT git clone https://github.com/Duckbox-Developers/apps"
		git clone https://github.com/Duckbox-Developers/apps apps
	    echo "$FORMAT -------------------------------------------"
		echo "$FORMAT link apps > buildsystem-ddt/apps"
		ln -s buildsystem-ddt/apps ../apps

		if [ "$(whoami)" == "obi" ];then
#		if [ ! -z "$SH4GIT" ] && [ "$SH4GIT" == "2" ];then
		    echo "$FORMAT -------------------------------------------"
#			echo "$FORMAT git clone https://github.com/openaaf/driver"
#			git clone https://github.com/openaaf/driver driver
		    echo "$FORMAT -------------------------------------------"
			echo "$FORMAT git clone https://github.com/openaaf/driver_ddt"
			git clone https://github.com/openaaf/driver_ddt driver
		else
		    echo "$FORMAT -------------------------------------------"
			echo "$FORMAT git clone https://github.com/Duckbox-Developers/driver"
			git clone https://github.com/Duckbox-Developers/driver driver
		fi

	    echo "$FORMAT -------------------------------------------"
		echo "$FORMAT link driver > buildsystem-ddt/driver"
		ln -s buildsystem-ddt/driver ../driver

	    echo "$FORMAT -------------------------------------------"
		echo "$FORMAT git clone https://github.com/Duckbox-Developers/flash"
		git clone https://github.com/Duckbox-Developers/flash flash

	    echo "$FORMAT -------------------------------------------"
		echo "$FORMAT link flash > buildsystem-ddt/flash"
		ln -s buildsystem-ddt/flash ../flash

	    echo "$FORMAT -------------------------------------------"
		echo "$FORMAT link tufsbox > buildsystem-ddt/tufsbox"
		ln -s buildsystem-ddt/tufsbox ../tufsbox

#		if [ "$(whoami)" == "obi" ];then
		if [ ! -z "$SH4GIT" ] && [ "$SH4GIT" == "2" ];then
			mv root/boot root/boot_org
		    echo "$FORMAT -------------------------------------------"
			echo "$FORMAT svn co --username buildbin --password buildbin http://svn.dyndns.tv/svn/tools/boot"
			svn co --username buildbin --password buildbin http://svn.dyndns.tv/svn/tools/boot root/boot
		    echo "$FORMAT -------------------------------------------"
			echo "$FORMAT add dummy root/boot/audio_7109.elf"
			touch root/boot/audio_7109.elf
		fi
		;;
	pull)
		cd $DIR/buildsystem-ddt
	    echo "$FORMAT -------------------------------------------"
		echo "$FORMAT git pull buildsystem-ddt"
		git pull
	    echo "$FORMAT -------------------------------------------"
		cd $DIR/buildsystem-ddt/apps
	    echo "$FORMAT -------------------------------------------"
		echo "$FORMAT git pull buildsystem-ddt/apps"
		git pull
		cd $DIR/buildsystem-ddt/driver
	    echo "$FORMAT -------------------------------------------"
		echo "$FORMAT git pull buildsystem-ddt/driver"
		git pull
		cd $DIR/buildsystem-ddt/flash
	    echo "$FORMAT -------------------------------------------"
		echo "$FORMAT git pull buildsystem-ddt/flash"
		git pull
		;;
esac

exit

case "$1" in
	clone)
		for f in  $REPLIST ; do
			if [ "$f" = "cdk" ]; then
				gitpath=TitanNit
			else
				gitpath=Duckbox-Developers
			fi
			if [ -d "$f" ]; then
				echo "$f already cloned"
			else
				if [ "$2" = "dev" ]; then
					# dev
					git clone git@github.com:$gitpath/$f $f
				else
					# usr
					git clone git://github.com/$gitpath/$f $f
				fi
				echo "git clone" $f from $gitpath
			fi
		done
		#sudo $DIR/prepare4cdk.sh
		;;
	pull)
		for f in  $REPLIST ; do
			cd $DIR/$f
			echo "$GITPULL" $f
			$GITPULL
			cd ..
			done
			;;
	push)
		for f in  $REPLIST ; do
			cd $DIR/$f
			echo "$GITPUSH" $f
			$GITPUSH
			cd ..
			done
			;;
	status)
		for f in  $REPLIST ; do
			cd $DIR/$f
			echo "$GITSTATUS" $f
			$GITSTATUS
			cd ..
			done
			;;
	*)
		if [ -d cdk ]; then
			echo "Usage: {clone | pull | push | status}"
			exit 1
		else
			$0 clone
		fi
		;;
esac
