# PS2Ripper

A bash script for ripping PS2 game disks back to back

## How to start

The script accepts 2 inputs, the directory in which to put the ISO files and a disk drive. Both are optional.

Run it like this:
```
sudo ./ripper.sh
```

Alternatively:
```
sudo ./ripper.sh /some/directory /dev/cdrom
```
The default device the script looks for is ``/dev/sr0``. If your drive has a different device name, specifying it like above may help.

## How to use

The script will open the dvd drive and ask you to insert a disk. Just lay the disk in the tray and press enter.

If you're done ripping, type anything at this screen and press enter to quit. Or just press Ctrl+c.

## Unreadable disks

When the ripper finds a disk is not fully readable it will give the user an error message, delete the ISO and eject the disk. You can either clean the disk and try again or insert a different disk. If cleaning doesn't work, the disk is likely damaged.
