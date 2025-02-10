# Creating an `initramfs`

## Motivation
The concept of `initramfs` is quite simple: a compressed mini-filesystem that is loaded into RAM and contains the init process. Here, I will discuss how an `initramfs` is made and how to make the kernel use it.

## Building the Directory Structure
I simply made a few empty folders that resemble a traditional rootfs and put my `init` aka the `dash` shell cross-built into it. 

```bash
tree .

├── bin
├── mnt
├── proc
├── sbin
└── init
```

## Creating an Archive

The next step is compressing this structure into a `.cpio` file: a deprecated compression algorithm that is only used in `initramfs` nowadays because of the ease it can be decompressed by the kernel.

```bash
sudo find . | cpio -H newc -ov > rootramfs.cpio
```

## Testing The `initramfs`

Move the `rootramfs.cpio` into your boot partition. Then edit the following sections in your `extlinux.conf` file.

```
initrd ../rootramfs.cpio
append 8250.nr_uarts=1 console=ttyS0,115200n8 rdinit=/sbin/init 
```