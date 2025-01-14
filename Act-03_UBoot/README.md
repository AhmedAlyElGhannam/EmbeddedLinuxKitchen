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
make ARCH=arm CROSS_COMPILE=arm-nemesis-linux-gnueabihf- -j10
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

