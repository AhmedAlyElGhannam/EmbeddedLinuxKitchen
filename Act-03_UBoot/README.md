# Our-Boot: Customizing a U-Boot Bootloader For QEMU && Raspberry Pi 3B+

## Prerequisites

1. Clone `u-boot` repository.

    ```bash
    git clone https://github.com/u-boot/u-boot.git
    ```

1. Checkout a **working tag.** The one that worked for me was `v2025.01`.

    ```bash
    git checkout v2025.01
    ```

## QEMU Edition

### Customizing U-Boot

1. I will be using an `ARM CORTEX-A9` machine on `qemu`. So, I will choose the configuration named `vexpress_ca9x4_defconfig`. All configurations can be found in the directory `configs` inside the `u-boot` directory.

    ```bash
    ls configs/ | grep a9
    # copy the config name named vexpress_ca9x4_defconfig
    ```

1. To apply this configuration, simply:

    ```bash
    make vexpress_ca9x4_defconfig
    ```

1. Enter the TUI configuration menu and apply the following changes:

    ```bash
    make menuconfig
    ```
    1. `Environment` -> **Disable** `Environment in Flash Memory`.
    1. `Environment` -> **Enable** `Environment is in a FAT Filesystem`.
    1. `Environment` -> **Edit** `Device and partition for where to store the environemt in FAT` => Enter `0:1`.
    1. `Boot Options` -> `Autoboot Options` -> **Change** `delay in seconds before automatically booting` to `10` seconds.
    1. `Command Line Interface` -> **Change** `Shell Prompt` to `Out-Boot=>`.

1. Once you are done, press `esc` twice, save and exit.

### Building U-Boot

You need a toolchain in order to build u-boot for the specified architecture. I used the one I built using `Crosstool-NG` with `glibc`; so feel free to check it out before continuing.

To build `u-boot`, I defined the used toolchain prefix and architecture, in addition to the number of cores assigned to the build process. I added the shell command `time` at the beginning to calculate the time to build it: it took about 30 seconds.

```bash
time make ARCH=arm CROSS_COMPILE=arm-nemesis-linux-gnueabihf- -j10
```

There are two files that are needed after building is done: `u-boot` (an elf executable), and `u-boot.bin` (a binary executable). Both achieve the same goal but I will be using the `.bin` version since it is smaller in size.

### Launching QEMU with U-Boot

In order to launch `qemu` with `u-boot`, run the following command:

```bash
qemu-system-arm -M vexpress-a9 -kernel u-boot -nographic
```

### Results

![](./README_Photos/qemu.png)


## Raspberry Pi 3B+ Edition

1. . I will be using a Raspberry Pi 3B+---which uses the SOC `BCM2837` based on ARM CORTEX-A53, I will be using its default configuration provided by `u-boot` under the name `rpi_3_b_plus_defconfig`. 

    ```bash
    ls configs/ | grep rpi
    # copy the config name named rpi_3_b_plus_defconfig
    ```

1. To apply this configuration, simply:

    ```bash
    make rpi_3_b_plus_defconfig
    ```

1. Enter the TUI configuration menu and apply the following changes:

    ```bash
    make menuconfig
    ```
    1. `Boot Options` -> `Autoboot Options` -> **Change** `delay in seconds before automatically booting` to `10` seconds.
    1. `Command Line Interface` -> **Change** `Shell Prompt` to `Out-Boot>`.

1. Once you are done, press `esc` twice, save and exit.

### Building U-Boot

You need a toolchain in order to build u-boot for the specified architecture. I used the one I built using `Crosstool-NG` with `glibc`; so feel free to check it out before continuing.

To build `u-boot`, I defined the used toolchain prefix and architecture, in addition to the number of cores assigned to the build process. I added the shell command `time` at the beginning to calculate the time to build it: it took about 30 seconds.

```bash
time make ARCH=arm CROSS_COMPILE=aarch64-rpi3-linux-gnu- -j10
```

There are two files that are needed after building is done: `u-boot` (an elf executable), and `u-boot.bin` (a binary executable). Both achieve the same goal but I will be using the `.bin` version since it is smaller in size.


### Cloning The Virtual SD Card into a Physical One

Since Raspberry Pi 3B+ rely on an SD card as its primary disk to boot from, it needs to be formatted into two partitions and a lot of other shenanigans. Luckily, since this setup was already done with the Virtual SD Card in Act 02, I will just clone it using `dd` and it will be good to go! 

```bash
# my physical sd card name is sda
sudo dd if=sd.img of=/dev/sda
```

There is no need to specify neither block size nor transfer cycle count.


### Populating The `boot` Partition with Necessary Firmware/Files

Next step is to copy all the firmware files the Raspberry Pi 3B+ needs in order to boot into the `boot` partition. The files are:
1. `bootcode.bin` -> First stage bootloader (closed-source).
1. `start.elf` -> Second stage bootloader (also closed-source).
1. `fixup.dat` -> Auxiliary code for GPU to help `start.elf` run on GPU (also closed-source *see the pattern?*).
1. `bcm2710-rpi-3-b-plus.dtb` -> Device tree binary file.
1. `config.txt` -> Specifies a number of startup configurations:
    1. `kernel=u-boot.bin` -> This tells `start.elf` where to boot next.
    1. `arm_64bit=1` -> This specifies the architecture used. 
    1. `enable_uart=1` -> This enables UART.
1. `cmdline.txt` -> Specifies the partition where `rootfs` is located + the baud rate for serial (UART) communication.
1. `overlays/` -> This directory contains device tree source output files for all hardware perpherals present on the Raspberry Pi 3B+.

After copying the specified files + `u-boot.bin` into your `boot` partition, unmount the sd card.


### Preparing The Environment For Serially Communicating With RPi3B+

1. Use a USB-to-TTL for communication with RPi3B+ as shown in the picture below.

![](./README_Photos/ttl.jpg)

1. Download a serial terminal of your choice. I chose to use `gtkterm`.

    ```bash
    sudo apt install gtkterm -y
    ```

1. If your USB-to-TTL keeps getting disconnected as soon as it is connected to your computer, remove the package specified in this command:

    ```bash
    sudo apt remove brltty
    ```

1. Do not forget to add your user to the `dialout` group to have access on your serial port communication.

    ```bash
    sudo usermod -aG dialout $USER
    ```

1. Connect `Rx` of RPi3B+ with `Tx` of USB-to-TTL, `Tx` of RPi3B+ with `Rx` of USB-to-TTL, and `GND` of both as per the RPi3B+ pinout diagram provided below.

![](./README_Photos/pinout.jpg)

1. Connect the USB-to-TTL, then launch `gtkterm`.

    ```bash
    gtkterm -p /dev/ttyUSB0 -s 115200
    ```

1. Insert the SD card into the RPi3B+, then connect to a 5W power source.


### Results

![](./README_Photos/rpi3.png)