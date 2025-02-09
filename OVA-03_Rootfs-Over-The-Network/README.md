in /etc/exports

# Adding the path of RPi's rootfs on Thinkchad #
# /home/nemesis/Playground/Github_Repositories/ITI_EmbeddedLinux/EmbeddedLinuxKitchen/Act-09_Root-of-All-Problems/rootfsP1
# Adding RPi's IP address #
# 192.168.1.2 (rw, no-root-squash, no-subtree-check)


This way, the sd card will not use initrd and will only contain kernel + dtb + u-boot + overlays + bootflow + closed-source firmware


# CHANGE bootargs/append section in bootflow scan
console=ttyS0 root=/dev/nfs init=/linuxrc ip=192.168.1.2:::::eth0 nfsroot=192.168.1.3:/SRV-LOCATION, nfserver=3, tcp, rw
