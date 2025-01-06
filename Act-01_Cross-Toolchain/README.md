# Creating a Cross Toolchain Using Crosstool-NG


## Getting Started

1. Clone `crosstool-ng` repository.

    ```bash
    git clone https://github.com/crosstool-ng/crosstool-ng
    ```

1. Navigate into the cloned repository folder, then checkout the release tag `1.26.0`.

    ```bash
    git checkout crosstool-ng-1.26.0
    ```

1. Before diving in, install all the following packages to avoid any unnecessary errors during installation.

    ```bash
    sudo apt install autoconf automake bison bzip2 cmake flex g++ gawk gcc gettext git gperf help2man libncurses5-dev libstdc++6 libtool libtool-bin make patch python3-dev rsync texinfo unzip wget xz-utils -y
    ```

## Installation Process

1. It might be a good idea to visit [Crosstool-NG's Official Documentation](https://crosstool-ng.github.io/docs/) if you want to use an installation method other than the one used here: I used the `Hacker's Way`.

1. The first thing that needs to be run is `bootstrap` script. This script makes sure that all required packages are installed on your machine before building `crosstool-ng`.

    ```bash
    ./bootstrap
    ```

1. Run the following command to configure the installation of `crosstool-ng` to be local; aka in the repository directory to avoid path/permission shenanigans.

    ```bash
    ./configure --enable-local
    ```

1. Finally, run `make` to build it.

    ```bash
    make 
    ```

## Configuration Process

1. The first step is picking a base configuration for a specific architecture and tweaking it some more. You can view all available one via:

    ```bash
    ./ct-ng list-samples
    ```

1. Alternatively, you can use `| grep` to only view the architectures you want.

    ```bash
    ./ct-ng list-samples | grep arm
    ```

1. In this lab, the configuration that was used was for `arm-cortex-a9` since it is backward-compatible with Beaglebone's `cortex-a8` architecture.

    ```bash
    ./ct-ng arm-cortexa9_neon-linux-gnueabihf
    ```

1. Now, for the fun part: open the TUI configuration menu and configure the following settings by yourself:

    ```bash
    ./ct-ng menuconfig
    ```
    1. `Paths and Misc Options` -> **Disable** Render toolchain read-only.
    1. `Toolchain Options` -> **Change** Tuple's vendor string (to whatever your heart desires).
    1. `C-Library` -> **Change** C-Library (Type and Version---I built this toolchain 3 times with 3 different C Libraries: `glibc`, `musl`, `uClibc`).
    1. `Debug Facilities` -> **Enable** `gdb` and `strace`.
    1. `Companion Tools` -> **Enable** `make`.

1. Once you are done, press `esc` twice, save and exit.


## Building The Toolchain

1. Before building, run the following command to view the number of logical processors on your machine. 

    ```bash
    nproc
    ```
1. To build, simply run `./ct-ng build`. **However**, I suggest that you add the flag `-j` with the number of processors you want to assign to the build operation. Since I have `12` logical processors, I assigned `10` to the build process and left the other 2 to make sure my machine does not halt/explode in my face. Additionally, the command `time` is good to use when building anything to know the time the process took; but `crosstool-ng` builder already tells you the time so you might ignore the option.

    ```bash
    time ./ct-ng build -j10
    ```

1. The build process took 30 minutes on average. It may vary depending on the library you are building (glibc is way larger that the other two), the specs of your machine, and how fast your machine throttles.

## Testing The Toolchain

1. If you did not explicitly change the path of the built toolchain, you should find it in `/home/$USER/x-tools/`.
1. In order to use it from anywhere, add the path of the toolchains' binaries to `PATH` environment variable in `.bashrc`.

    ```bash
    vim ~/.bashrc
    # add the PATH line to .bashrc
    PATH="/home/nemesis/x-tools/arm-nemesis-linux-musleabihf/bin/:/home/nemesis/x-tools/arm-nemesis-linux-gnueabihf/bin/:/home/nemesis/x-tools/aarch64-rpi4-linux-gnu/bin/:$PATH" 
    ```

1. Source `.bashrc` to apply the changes to your path variable.

    ```bash
    source ~/.bashrc
    ```

1. I wrote a simple c app that prints a sentence on the stdout.

    ```c
    #include <stdio.h>

    int main(void)
    {
            printf("Hello From The Other Siiiiiiide!\n");
            return 0;
    }
    ```

1. I then compiled it using the toolchain that uses `musl`. Just replace the toolchain name with yours.

    ```bash
    arm-nemesis-linux-musleabihf-gcc main.c -o main
    ```

1. Using the command `file`, you can see that the output executable is compiled for `arm 32-bit`

    ```bash
    file main
    # output:
    main: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/ld-musl-armhf.so.1, not stripped
    ```

## Running Executables on QEMU

1. The first step to running stuff on `qemu` is making sure `qemu` and all of its shenanigans are installed. Run the following commands to make sure you do not miss anything.

    ```bash
    sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager
    sudo apt install -y qemu qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager virtinst cpu-checker
    sudo apt install -y qemu-system qemu-user qemu-user-static
    sudo apt install -y qemu-system-arm qemu-system-mips qemu-system-ppc qemu-system-sparc qemu-system-x86
    sudo systemctl enable libvirtd
    sudo systemctl start libvirtd
    sudo systemctl status libvirtd
    sudo usermod -aG kvm $USER
    sudo usermod -aG libvirt $USER
    ```

1. Finally, you can call `qemu-arm` and pass the executable to it. Bare in mind that it will not run **unless you pass the path of the toolchain's sysroot**. The `sysroot` is a directory that acts as a pseudo-filesystem that allows dynamic linking with libraries even if the target does not have an operating system

    ```bash
    qemu-arm -L /home/nemesis/x-tools/arm-nemesis-linux-musleabihf/arm-nemesis-linux-musleabihf/sysroot main    
    ```

## Results

![](./README_Photos/glibc.png)
![](./README_Photos/musl.png)