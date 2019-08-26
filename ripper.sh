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

TIMEOUT=60

while true; do
  eject
  echo "Insert a disk and press enter"
  read input
  if [ ! -z "$input" ]; then
    exit
  fi

  # close the drive and wait for the drive to be mounted
  TIMEWAITED=0
  FAILED=0
  while [ -z "$(df ${DRIVE}|grep ${DRIVE})" ] ; do
    sleep 1
    TIMEWAITED=$((TIMEWAITED+1))
    if [ "$TIMEWAITED" -gt "${TIMEOUT}" ]; then
      FAILED=1
      break
    fi
  done

  if [ $FAILED -eq 1 ]; then
    echo "Couldn't read disk"
    continue
  fi

  MOUNTPOINT="$(df /dev/sr0|tail -1|tr -s ' '|cut -d ' ' -f 6-)"
  echo "Disk mounted at ${MOUNTPOINT}"
  if [ ! -f "${MOUNTPOINT}/SYSTEM.CNF" ] && [ ! -f "${MOUNTPOINT}/system.cnf" ]; then
    echo "Couldn't find ${MOUNTPOINT}/SYSTEM.CNF, this is probably not a PS2 game"
    continue
  fi

  VOLNAME="$(volname ${DRIVE}| sed 's/[ ^t]*$//')"
  CODENAME=$(find "${MOUNTPOINT}/" -maxdepth 1 -iname '*SYSTEM.CNF' -print0 -quit|xargs -0 cat|head -1| cut -f2 -d'\'|cut -f1 -d';'|tr -d '.')
  if [ -z ${VOLNAME} ] || [ "${VOLNAME}" == "${CODENAME}" ]; then
    ISONAME="${CODENAME}.iso"
  else
    ISONAME="${CODENAME}-${VOLNAME}.iso"
  fi
  echo "Ripping game as ${ISONAME}"
  dd if="${DRIVE}" of="${DEST}/${ISONAME}"
  if [ ! $? -eq 0 ]; then
    echo "Read not fully readable, please clean the disk and try again"
    rm ${DEST}/${ISONAME}
  fi
done
