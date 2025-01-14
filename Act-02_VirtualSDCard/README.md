# Creating a Virtual SD Card For QEMU Shenanigans

## Creating a File

The first step create a virtual SD card is to simply create a file. This file will act as the foundation for the SD card that will be created. File extension does not matter but it is here simply to facilitate understanding its purpose from the name alone.

```bash
touch sd.img
```


## Padding The File To Reach The Required Size

The second step is to pad the file with `NULL` characters until it reaches a size that fits our use. Here, I used the command `dd` to transfer a determined amount of the `NULL` character stream present in `/dev/zero`. In addition, I added the options `bs` and `count`: `bs` determines the data block size being transfered per cycle, while `count` defines the number of required memory transfer cycles. I chose to fill it until it reached a size of 1GB.

```bash
dd if=/dev/zero of=sd.img bs=1M count=1024
```


## Formatting The Virtual Disk

Now, this pile of zeros must be formatted into something that resembles an actual disk. So, the next step is to format it into an MBR disk: aka, creating an MBR table at the beginning of the disk that explains how many partitions this disk will have; which partition is bootable; and the used file system in each partition. To achieve this, I used a terminal tool called `cfdisk` and did the following:

```bash
cfdisk sd.img

# choose DOS

# create a partition with size 200M + make it bootable + choose the filesystem as FAT16 (option 6)

# create a partition with the rest of the available space + choose the filesystem as EXT4 (option 83)

# choose write, then exit
```

It should look like the picture below before exiting:

![](./README_Photos/MBR.png)


## Mounting Partitions as Loop Devices 

With the MBR table out of the way, the next step is to actually define the partitions' filesystems as specified in the MBR table. But, this cannot be done unless the virtual SD card is mounted as an actual device. In order to do that, it can simply be mounted as a loop device. A loop device in Linux is a virtual block device that is often used by snap packages and managed by the kernel---i.e., a determined number of loop devices is available on a fresh boot depending on the available memory on one's system. A user can choose to mount a "file" as a loop device to treat it just like a normal block device: meaning that one can create a filesystem for its partitions in order to store files inside it.

```bash
sudo losetup --partscan --show -f sd.img
```

After executing the previous command, the file `sd.img` got mounted to `loop22` and it shows that it contains two partitions: `loop22p1` and `loop22p2`. Bare in mind that these partitions cannot be accessed yet since they have no filesystem.


## Creating Filesystems for Defined Partitions

Now, it is time to create a filesystem for the mounted partitions. To do this, I used the command `mkfs` on both partitions; specifying the filesystem type for each partition. Additionally, I gave each of these partitions a name.

```bash
mkfs.vfat -F 16 -n boot /dev/loop22p1
mkfs.ext4 -L rootfs /dev/loop22p2
```


## Mounting The Loop Device

By default, upon attaching a "file" as a loop device, it is present on your system but it is not mounted. In order to mount, for example, the `boot` partition, simply:

```bash
# I have created a directory named boot where I executed this command
mount /dev/loop22p1 ./boot
```


## Results

I have created a file inside the `boot` partition inside `sd.img`.

![](./README_Photos/file_present_when_mounted.png)
![](./README_Photos/file_present_in_img.png)