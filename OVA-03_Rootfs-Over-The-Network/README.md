# Network File Systems Demo

## Server-Side Setup
1. Install the package `nfs-kernel-server`.
  ```bash
  sudo apt install nfs-kernel-server -y
  ```
1. Edit the file `/etc/exports` as `sudo` and add the following line.
   ```bash
   sudo vim /etc/exports
   # rootfs location on laptop + Pi's IP + extra settings
   /home/nemesis/OverTheNetwork/rootfs 192.168.1.2(rw,no_root_squash,no_subtree_check)
   ```
1. Apply the settings.
  ```bash
  sudo exportfs -r
  ```
1. Set an IP address to your laptop's ethernet interface.
   ```bash
   sudo ip a add 192.168.1.3/24 dev enp0s31f6
   ```

## Changes to Pi's Boot Partition
1. Change the `append` line (modify bootargs) in extlinux.conf file to be as follows:
  ```
  setenv bootargs "8250.nr_uarts=1 console=ttyS0,115200n8 root=/dev/nfs ip=192.168.1.2:::::eth0 nfsroot=192.168.1.3:/home/nemesis/OverTheNetwork/rootfs,nfsvers=3,tcp rw init=/linuxrc"
  ```

Power on the Pi and execute your usual `bootflow scan`, you will find that the rootfs that is mounted on the Pi is the one on your laptop!
This way, the sd card will not use initrd and will only contain kernel + dtb + u-boot + overlays + bootflow + closed-source firmware


# CHANGE bootargs/append section in bootflow scan
console=ttyS0 root=/dev/nfs init=/linuxrc ip=192.168.1.2:::::eth0 nfsroot=192.168.1.3:/SRV-LOCATION, nfserver=3, tcp, rw
