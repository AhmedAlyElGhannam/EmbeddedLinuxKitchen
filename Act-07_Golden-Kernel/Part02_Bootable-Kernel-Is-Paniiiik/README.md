# Building The Linux Kernel

## Getting Started

The first step is to clone Linux repository from Github.
```bash 
git clone https://github.com/torvalds/linux.git
```

Alternatively, if you are building it to a Raspberry Pi, it is more recommended to clone their fork of Linux since it contains their default configuration to ease the building/configuration process.
```bash
git clone https://github.com/raspberrypi/linux.git
```

Go to the repository's directory and checkout the latest stable branch.
```bash
cd linux
git checkout rpi-6.6.y
```

## Configuring The Kernel
Default configurations are located under `arch/BOARD_ARCH/configs/`. Since I am building the kernel for Raspberry Pi 3B+, my `BOARD_ARCH` is `arm64` and the configuration file is named `bcmrpi3_defconfig`. Apply this configuration by running the following command. It is a good idea to export the environment variables `ARCH` and `CROSS_COMPILE` beforehand with values matching your board. Or, just pass them with every command like I do.
```bash
make bcmrpi3_defconfig ARCH=arm64 CROSS_COMPILE=aarch64-rpi3-linux-gnu-
```

You can go into the TUI configuration menu and tweak a few settings. I left it as it is.
```bash
make menuconfig
```

## Building The Kernel & DTB
All that remains is to build the kernel and all board-specific files like overlays and dtb. I specified the kernel image format as `Image` since I want to produce a 64-bit kernel.
```bash
time make -j12 Image dtbs ARCH=arm64 CROSS_COMPILE=aarch64-rpi3-linux-gnu-
```

## Output
The kernel can be found under `linux/arch/arm64/boot`, the device tree binary can be found in `linux/arch/arm64/boot/dts/broadcom` under the name `bcm2837-rpi-3-b-plus.dtb`. Move them into your `boot` partition.

## Autobooting Using U-Boot Bootscript
Booting into Linux is a very straightforward process: you have to load the kernel & dtb into their specified addresses in RAM 
and specify the right boot arguments to pass to the kernel. This can be done via entering the commands manually in U-Boot or, alternatively, putting them into a script and tell U-Boot to source it on autoboot.

The process goes as follows:Make a `.txt` file containing these commands in the following order. This script loads the kernel and dtb from mmc device if the device exists or requests them from tftp server. Then, saves the required bootargs and saves the command to run the script in `bootcmd` to run it on autoboot. 
```
setenv kernel_file Image
setenv fdt_file bcm2837-rpi-3-b-plus.dtb
setenv ipaddr 192.168.1.5
setenv checkIfMMCDeviceExists \
"if mmc dev; then run loadImageFromFAT; else run loadImageFromTFTP; fi"
setenv loadImageFromFAT \
"if fatload mmc 0:1 $kernel_addr_r Image; then run loadDTBFromFAT; else run loadImageFromTFTP; fi"
setenv loadDTBFromFAT \
"if fatload mmc 0:1 $fdt_addr_r bcm2837-rpi-3-b-plus.dtb; then run bootImage; else run loadImageFromTFTP; fi"
setenv loadImageFromTFTP \
"if tftp $kernel_addr_r Image; then run loadDTBFromTFTP; else echo AYO!; fi"
setenv loadDTBFromTFTP \
"if tftp $fdt_addr_r bcm2837-rpi-3-b-plus.dtb; then run bootImage; else echo FAILURE!; fi"
setenv bootImage \
"booti $kernel_addr_r - $fdt_addr_r"
setenv bootcmd "run checkIfMMCDeviceExists"
setenv bootargs "root=/dev/mmcblk0p2 rw rootfstype=ext4 8250.nr_uarts=1 console=ttyS0,115200n8 init=/sbin/init"
saveenv
```

If you think this is all you have to do, you thought wrong! Bootscripts must be binary files; meaning that `u-boot` will see the above script as a text file that is not executable and will through you an error if you try to source it. 

Luckily, a tool that does the conversion process for me exists. All you have to do is install the package specified:

```bash
sudo apt install u-boot-tools
```

Then, use the tool called `mkimage` to "compile" the script.
```bash
mkimage -T script -n "Bootscript" -C none -d uboot-script.txt Rpi3B-bootscript
```

Move the script into your `boot` partition, run it, then reboot.

## Results
[Booting into Kernel Using Bootscript Showcase](https://github.com/user-attachments/assets/0d525301-c393-4f8f-b123-3ef0fa2f9f28)
