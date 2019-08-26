#!/bin/bash

if [ $EUID -ne 0 ]; then
	echo "$(basename $0) must be run as root"
	exit 1
fi

DEST=$1
if [ -z $DEST ]; then
  DEST="${PWD}"
fi

DRIVE=$2
if [ -z $DRIVE ]; then
  DRIVE="/dev/sr0"
fi


while true; do
  eject
  echo "Insert a disk and press enter"
  read input
  if [ ! -z "$input" ]; then
    exit
  fi

  # close the drive and wait for the drive to be mounted
  while [ -z "$(df ${DRIVE}|grep ${DRIVE})" ] ; do
    sleep 1
  done

  MOUNTPOINT="$(df /dev/sr0|tail -1| awk '{ print $6 }')"
  echo "Disk mounted at ${MOUNTPOINT}"
  VOLNAME="$(volname ${DRIVE}| sed 's/[ ^t]*$//')"
  CODENAME="$(find ${MOUNTPOINT} -maxdepth 1 -iname '*SYSTEM.CNF'|head -1|xargs cat|head -1| cut -f2 -d'\'|cut -f1 -d';'|tr -d '.')"
  if [ -z ${VOLNAME} ]; then
    ISONAME="${CODENAME}.iso"
  else
    ISONAME="${CODENAME}-${VOLNAME}.iso"
  fi
  echo "Ripping game as ${ISONAME}"
  dd if="${DRIVE}" of="${DEST}/${ISONAME}"
  if [ ! -z $? ]; then
    echo "Read not fully readable, please clean the disk and try again"
    rm ${DEST}/${ISONAME}
  fi
done
