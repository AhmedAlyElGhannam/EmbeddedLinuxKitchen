# Creating a U-Boot Bootscript

## Motivation
In order to launch a program using `u-boot`, it has to be loaded in an address in the DRAM that is specific for applications/executable; then the user asks `u-boot` to jump to said address to execute the program. If you think this is a troublesome process you are absolutely right! This is why a concept known as `bootscript` was introduced to fully automate the process: on autoboot, said boot script will execute a set of commands for you. 

## Writing a Bootscript

The script I wrote (its extension is .txt) is quite simple: if the binary executable named `blinky.img` exists in `mmc 0:1`, load it into DRAM at address 0xC100000; else, use TFTP to request it via ethernet from TFTP server; if all of that fails, simply print an error message on the terminal.

The script is as shown below:

```uboot
setenv loadFromFAT \
"if mmc dev; then run checkFileExistInMMC; else run loadFromTFTP; fi"

setenv checkFileExistInMMC \
"if fatload mmc 0:1 0xC100000 blinky.img; then echo Done!; else run loadFromTFTP; fi"

setenv loadFromTFTP \
"if tftp 0xC100000 blinky.img; then echo Done!; else echo AYO!; fi"

setenv bootcmd "run loadFromFAT"

saveenv
```

If you think this is all you have to do, you thought wrong! Bootscripts must be binary files; meaning that `u-boot` will see the above script as a text file that is not executable and will through you an error if you try to source it.

## Changing Boot Script Format From ASCII To Binary

Luckily, a tool that does the conversion process for me exists. All you have to do is install the package specified:

```bash
sudo apt install u-boot-tools
```

All that remains is to use a tools called `mkimage` to convert the script format. I used the following command:

```bash
mkimage -T script -n "Bootscript" -C none -d uboot-script.txt Rpi3B-bootscript
```

This gave me a binary bootscript called `Rpi3B-bootscript`. I then copied the script to `boot` partition in sd-card.

## Running the Script

Next step is to load the script into an address in DRAM. Since it is executable, I loaded it in address `0x80000`.
![](./README_Photos/source.jpeg)

Once that is done, all that is left is to reset and view the results for yourself!

## Results
![](./README_Photos/autoboot.jpeg)