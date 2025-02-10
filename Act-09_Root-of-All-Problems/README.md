# Busybox-based Roofs & Init Process

## Introduction
This act marks the final stage in building a Linux image from scratch: creating binaries and init process using Busybox and booting into the image.

## Busybox: Binaries & Init Process
### Setting Up Busybox
1. Start things off by cloning busybox's repository.
    ```bash
    git clone git://busybox.net/busybox.git
    ```
1. Change directory into the cloned busybox and checkout the latest stable branch.
    ```bash
    cd busybox
    git checkout remotes/origin/1_36_stable
    ``` 
1. Wipe out any previous configuration files that may have made their way here and set the default configuration.
    ```bash
    make distclean
    make defconfig
    ```
1. Enter the TUI configuration menu and adjust the following:
    ```bash
    make menuconfig
    ```
    1. `Settings` -> **Enable** Build static binary (no shared libraries).
    1. `Settings` -> **Set** Cross compiler prefix to `aarch64-rpi3-linux-gnu-`.
    1. `Networking utilities` -> **Disable** `tc`. **[If You Encounter An Error Related to Networking/tc Package While Building]** 

### Building Busybox
Building busybox is a pretty straight forward process: all you have to do is run
```bash
make -j12
```
and you are good. All that is left is to install the built binaries into a directory. By default, the installation folder is called `_install` and located in busybox's directory.
```bash
make install
```

Busybox's whole gimmick is to make one binary `busybox` and multiple binaries that are symbolic links to this one binary. `busybox` is smart enough to resolve calling `cp` for example as the command `cp` passed to `busybox` as an argument: executing the functionality of `cp` in the process.

### Constructing Rootfs
1. Copy the directories present in `_install` into a new folder.
1. Populate the directories you copied from busybox's output with the toolchain'sysroot.

Your rootfs should look like this:
```bash
tree -d .
├── bin
├── dev
├── etc
│   └── init.d
├── lib
├── lib64 -> lib
├── proc
├── sbin
├── sys
├── usr
│   ├── bin
│   ├── include
│   │   ├── arpa
│   │   ├── asm
│   │   ├── asm-generic
│   │   ├── bits
│   │   │   └── types
│   │   ├── drm
│   │   ├── finclude
│   │   ├── gdb
│   │   ├── gnu
│   │   ├── linux
│   │   │   ├── android
│   │   │   ├── byteorder
│   │   │   ├── caif
│   │   │   ├── can
│   │   │   ├── cifs
│   │   │   ├── dvb
│   │   │   ├── genwqe
│   │   │   ├── hdlc
│   │   │   ├── hsi
│   │   │   ├── iio
│   │   │   ├── isdn
│   │   │   ├── misc
│   │   │   ├── mmc
│   │   │   ├── netfilter
│   │   │   │   └── ipset
│   │   │   ├── netfilter_arp
│   │   │   ├── netfilter_bridge
│   │   │   ├── netfilter_ipv4
│   │   │   ├── netfilter_ipv6
│   │   │   ├── nfsd
│   │   │   ├── raid
│   │   │   ├── sched
│   │   │   ├── spi
│   │   │   ├── sunrpc
│   │   │   ├── surface_aggregator
│   │   │   ├── tc_act
│   │   │   ├── tc_ematch
│   │   │   └── usb
│   │   ├── misc
│   │   │   └── uacce
│   │   ├── mtd
│   │   ├── net
│   │   ├── netash
│   │   ├── netatalk
│   │   ├── netax25
│   │   ├── neteconet
│   │   ├── netinet
│   │   ├── netipx
│   │   ├── netiucv
│   │   ├── netpacket
│   │   ├── netrom
│   │   ├── netrose
│   │   ├── nfs
│   │   ├── protocols
│   │   ├── rdma
│   │   │   └── hfi
│   │   ├── rpc
│   │   ├── scsi
│   │   │   └── fc
│   │   ├── sound
│   │   │   ├── intel
│   │   │   │   └── avs
│   │   │   └── sof
│   │   ├── sys
│   │   ├── video
│   │   └── xen
│   ├── lib
│   │   ├── audit
│   │   └── gconv
│   │       └── gconv-modules.d
│   ├── lib64 -> lib
│   ├── libexec
│   │   └── getconf
│   ├── sbin
│   └── share
│       ├── i18n
│       │   ├── charmaps
│       │   └── locales
│       └── locale
│           ├── be
│           │   └── LC_MESSAGES
│           ├── bg
│           │   └── LC_MESSAGES
│           ├── ca
│           │   └── LC_MESSAGES
│           ├── cs
│           │   └── LC_MESSAGES
│           ├── da
│           │   └── LC_MESSAGES
│           ├── de
│           │   └── LC_MESSAGES
│           ├── el
│           │   └── LC_MESSAGES
│           ├── en_GB
│           │   └── LC_MESSAGES
│           ├── eo
│           │   └── LC_MESSAGES
│           ├── es
│           │   └── LC_MESSAGES
│           ├── fi
│           │   └── LC_MESSAGES
│           ├── fr
│           │   └── LC_MESSAGES
│           ├── gl
│           │   └── LC_MESSAGES
│           ├── hr
│           │   └── LC_MESSAGES
│           ├── hu
│           │   └── LC_MESSAGES
│           ├── ia
│           │   └── LC_MESSAGES
│           ├── id
│           │   └── LC_MESSAGES
│           ├── it
│           │   └── LC_MESSAGES
│           ├── ja
│           │   └── LC_MESSAGES
│           ├── ko
│           │   └── LC_MESSAGES
│           ├── lt
│           │   └── LC_MESSAGES
│           ├── nb
│           │   └── LC_MESSAGES
│           ├── nl
│           │   └── LC_MESSAGES
│           ├── pl
│           │   └── LC_MESSAGES
│           ├── pt
│           │   └── LC_MESSAGES
│           ├── pt_BR
│           │   └── LC_MESSAGES
│           ├── ru
│           │   └── LC_MESSAGES
│           ├── rw
│           │   └── LC_MESSAGES
│           ├── sk
│           │   └── LC_MESSAGES
│           ├── sl
│           │   └── LC_MESSAGES
│           ├── sr
│           │   └── LC_MESSAGES
│           ├── sv
│           │   └── LC_MESSAGES
│           ├── tr
│           │   └── LC_MESSAGES
│           ├── uk
│           │   └── LC_MESSAGES
│           ├── vi
│           │   └── LC_MESSAGES
│           ├── zh_CN
│           │   └── LC_MESSAGES
│           └── zh_TW
│               └── LC_MESSAGES
└── var
    └── db
```

The rootfs is now as good as done.

## Building a Rootramfs With Init Process & Basic Utilities
### Building The Hierarchy
1. Start things off by creating the necessary directories.
    ```bash 
    mkdir bin dev etc sbin sys mnt mnt/root proc
    ```
1. Copy `busybox` binary created earlier and paste it in `rootramfs/bin/`
1. Create symbolic links with the following names to `busybox` in `/sbin`:
    1. `mount`.
    1. `echo`.
    1. `mdev`.
    1. `chroot`.
1. Create symbolic links named `linuxrc` and place it in `/` & `init` and place it in `/bin`.

### Creating `inittab` & `rcS`
The init process should, in essense, accomplish the following:
1. mount sys.
1. mount proc.
1. mount dev.
1. scan sys and populate dev.
1. mount rootfs partition.
1. change root to the mounted partition and launch a shell session.

This is accomplished via `rcS` script. Since it was required to have the ability to choose one of two rootfs to mount and switch to, I added this functionality to the script as shown here:
```bash
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs null /dev

echo /sbin/mdev > /proc/sys/kernel/hotplug
mdev -s  


echo "Waiting for /dev/sda1..."
while [ ! -e /dev/sda1 ]; do
    sleep 1
done
echo "/dev/sda1 detected!"

echo "Waiting for /dev/sda2..."
while [ ! -e /dev/sda2 ]; do
    sleep 1
done
echo "/dev/sda2 detected!"

mdev -s

echo "Choose the rootfs you want to mount."
echo "Enter 1 for rootfsP1 (/dev/sda1)."
echo "Enter 2 for rootfsP2 (/dev/sda2)."
read -p 'Your Choice: ' ROOTFS

if [[ "$ROOTFS" -eq 1 || "$ROOTFS" -eq 2 ]]; then
	mount -w -t ext4 /dev/sda${ROOTFS} /mnt/root
	exec chroot /mnt/root /linuxrc
else 
	echo "INVARG!"
	echo "Launching a shell in initrd instead..."
fi
```

**DO NOT FORGET TO MAKE IT EXECUTABLE**

## Testing It Out
1. Create a `.cpio` archive for rootramfs.
    ```bash
    sudo find . | cpio -H newc -ov > rootramfs.cpio
    ```
1. Since I faced an issue with the Pi 3 where the rootfs partitions refused to get recognized by the kernel, I formated a USB flash drive and made 2 identical partitions with the exception of a single file named `rootfsP1` and `rootfsP2` respectively just to recognize the mounted partition.

1. Connect the USB drive and sd card to the Pi and boot.


## Results
It was a complete success!