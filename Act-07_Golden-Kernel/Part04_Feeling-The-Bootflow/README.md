# Making a Boot Menu Using Bootflows

## Introduction
Unless you have been living under a rock, I am sure you are familiar with Grub. You should also be familiar with how it gives you the option to boot into 2 separate operating systems via a menu. This is quite cool. But you know what is cooler? Making that yourself on U-Boot for the Raspberry Pi 3B+.

The idea is to make a certain directory containing a file with special syntax and use U-Boot's `bootflow scan` command to parse this file and give you the option to boot with the specified settings.

## Constructing a Bootflow
1. Inside your `boot` partition, make a directory named `extlinux` and inside it a file named extlinux.conf.
1. This file specifies multiple things like:
    1. Default boot option.
    1. Autoboot timeout.
    1. Boot menu title.
    1. Bootflow label.
    1. Used kernel.
    1. Used flattened device tree.
    1. Used initramdisk.
    1. Used bootargs.

1. I used the example file listed [here](https://github.com/jetsonhacks/bootFromUSB/tree/main) created by [jetsonhacks](https://github.com/jetsonhacks) as my template.