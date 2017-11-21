#!/bin/sh

DIR=`pwd`
GITPULL="git pull"
GITPUSH="git push origin master"
GITSTATUS="git status"
REPLIST="apps cdk driver flash"

case "$1" in
	clone)
		echo "git pull buildsystem-ddt"
		git clone https://github.com/TitanNit/buildsystem-ddt buildsystem-ddt
		ln -s buildsystem-ddt cdk

		cd $DIR/buildsystem-ddt

		echo "git pull buildsystem-ddt/apps"
		git clone https://github.com/Duckbox-Developers/apps apps
		ln -s buildsystem-ddt/apps ../apps

		echo "git pull buildsystem-ddt/driver"
		git clone https://github.com/Duckbox-Developers/driver driver
		ln -s buildsystem-ddt/driver ../driver

		echo "git pull buildsystem-ddt/flash"
		git clone https://github.com/Duckbox-Developers/flash flash
		ln -s buildsystem-ddt/flash ../flash
		;;
	pull)
		cd $DIR/buildsystem-ddt
		echo "git pull buildsystem-ddt"
		git pull
		cd $DIR/buildsystem-ddt/apps
		echo "git pull buildsystem-ddt/apps"
		git pull
		cd $DIR/buildsystem-ddt/driver
		echo "git pull buildsystem-ddt/driver"
		git pull
		cd $DIR/buildsystem-ddt/flash
		echo "git pull buildsystem-ddt/flash"
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
