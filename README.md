# PS2Ripper

A simple bash script to rip PS2 games in bulk.

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
