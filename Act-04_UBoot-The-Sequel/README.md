# U-Boot: Walkthrough Terminology & Loading Things into RAM

This file contains all of U-Boot's most important commands/environment variables just in case I needed them again. 

## Commands
1. `fatload` &rarr; used to load a file from a FAT-formated partition of a storage device into RAM.
    ```
    fatload mmc 0:1 $addr_r FILE_NAME
    ```

1. `saveenv` &rarr; used to save the current values of environment variables in a `uboot.env` file in the same partition `u-boot.bin` is located in.  
    ```
    saveenv
    ```

1. `ls` &rarr; used to list the files inside a device partition.
    ```
    ls mmc 0:1
    ```

1. `bdinfo` &rarr; used to show board info like the start address of RAM.
    ```
    bdinfo
    ```

1. `booti` &rarr; used to boot into a 64-bit Linux kernel image in `Image` format. The load addresses of initrd and flattened device tree should be passed as well.
    ```
    booti $kernel_addr_r $ramdisk_addr_r $fdt_addr_r
    ```

1. `ping` &rarr; this command is used to test the line of communication with another device located on the same network.
    ```
    ping 192.168.1.5
    ```

1. `tftp` &rarr; this command is used to load a file into a RAM address via `TFTP`.
    ```
    tftp $kernel_addr_r FILE_NAME
    ```

1. `run` &rarr; this command is used to run a **binary** u-boot script.
    ```
    run SCRIPT_NAME
    ```

1. `go` &rarr; this command is used to execute a binary application loaded in a RAM address beforehand.
    ```
    go $RAM_addr_r
    ```
1. `printenv` &rarr; this command is used to view all environment variables and the values stored in them that are saved in `uboot.env` file.
    ```
    printenv
    ```

## Environment Variables

1. `bootcmd` &rarr; on powerup, U-Boot executes the commands stored inside this environment variable once autoboot countdown hits 0. **You can store commands like `bootflow scan` or `run bootScript` for example.**
    ```
    bootcmd
    ```
1. `bootargs` &rarr; this environment variable stores the arguments passed to the kernel upon booting.
    ```
    bootargs
    ```

1. `ipaddr` &rarr; this environment variable holds the board's IP address. This is relevant for applications like `TFTP`.
    ```
    setenv ipaddr 192.168.1.1
    ```

1. `serverip` &rarr; this environment variable holds the IP address of `TFTP` server.
    ```
    setenv serverip 192.168.1.2
    ```


## Bonus: Setting up a TFTP Server on PC

1. Install a `tftp` server.
    ```
    sudo apt install tftpd-hpa
    ```

1. Set an IP address for your ethernet port.
    ```
    sudo ip a add 192.168.1.3/24 dev enp0s31f6
    ```

1. Edit the configuration file of `tftpd-hpa` located in `/etc/default/` under the name `tftpd-hpa`.
    ```bash
    sudo vim /etc/default/tftpd-hpa
    #write inside the file
    tftf_option = “--secure –-create”
    # change the server directory
    TFTP_DIRECTORY="/srv/tftp"
    ```

1. Restart `tftp` service and check its status.
    ```bash
    Systemctl restart tftpd-hpa
    Systemctl status tftpd-hpa
    ```

1. Put the file that needs to be transfered to target in the server directory.
