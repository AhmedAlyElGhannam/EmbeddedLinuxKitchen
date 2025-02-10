# Buildroot Image For Raspberry Pi 3B+

1. clone buildroot repo navigate into buildroot directory
```bash
git clone https://github.com/buildroot/buildroot.git
```

1. list the available configurations and choose the one suitable for RPi3B+

1. set configuration
```bash
make raspberrypi3_64_defconfig
```

1. enter TUI configuration menu and enable the following settings then press esc twice to exit.
    ```
    make menuconfig
    ```
    1. `System Configuration` -> `Init System` -> Change it to SystemV.
    1. `System Configuration` -> `Root Password` -> set a root password
    1. `DIRECTLY UNDER ROOT PASSWORD` -> change default shell to bash
    1. `Target Packages` -> `Text Editors and Viewers` -> Add bat/less/vim/nano/emacs.
    1. `Target Packages` -> `Debugging, Profiling, and Benchmark` -> add gdb.
    1. `Target Packages` -> `Development Tools` -> Add make, grep, sed, git, tree.
    1. `Target Packages` -> `Games` -> Add ascii_invaders.
    1. `Target Packages` -> `Hardware Handling` -> add avrdude, openocd, u-boot-tools, picocom.
    1. `Target Packages` -> `Interpreter Languages and Scripting` -> add python3.
    1. `Target Packages` -> `Libraries` -> Contains tons of stuff like opencv4 under Graphics.
    1. `Target Packages` -> `Networking Applications` -> Add iw, open-ssh, connman, Enable Ethernet Support, Enable Wifi Support.
    1. `Target Packages` -> `Shells and Utilities` -> Add sudo, time, file, which, tmux, Neofetch for a drippy build.
    1. `Target Packages` -> `System Tools` -> Add htop (also can add start-stop-daemon from here)
    1. `Filesystem Images` -> `Set Exact Size` -> Set rootfs to 8G to accomodate all the added packages. (default is 150M and it will give you an error if you add a lot of packages saying it is out of space.)
    1. `Bootloaders` -> U-boot (enable)

1. build your image. it takes about an hour on my machine and it needs a strong internet connection.
```bash
time make -j12
```

1. navigate to the directory where the image got produced.
```bash
cd buildroot/output/images
```

1. you will find lots of files but the one of most importance is `sdcard.img`. use `dd` to clone it into your physical sd card. **MAKE SURE YOU SELECT THE RIGHT DEVICE CUZ DD WILL ERASE THE SPECIFIED DEVICE AND DATA WILL BE LOST**
```bash
sudo dd if=sdcard.img of=/dev/sda
``` 

1. Plug the sd card into your RPi3B+.

1. Connect your USB-To-TTL to your PC and its Tx to the Pi's Rx && its Rx to the Pi's Tx.

1. Use a serial terminal like gtk

1. Make sure your user is in the dialout group.

1. If your USB-To-TTL keeps getting disconnected, delete the package named `brltty`.

1. Launch the serial terminal.

1. Connect power to the Pi.

## Enable SSH on Pi 

1. open the ssh configurating file in vim
```bash
vi /etc/ssh/sshd_config
```
1. add/uncomment the following fields then save and quit 
```
PermitRootLogin yes
PasswordAuthentication yes
```
1. restart ssh service
```bash
/etc/init.d/S50sshd restart
```

1. add an ip address for the Pi's ethernet. Make sure it belongs to the same network as the device you will ssh onto it from.
```bash
ip a add 192.168.1.3/24 dev eth0
```

1. connect an ethernet cable to Pi from one side and your PC from the other. use the command `ping` to make sure both devices see each other.
```bash
ping 192.168.1.3
```

1. From the PC, use the following command to ssh onto the Pi. You will be prompted to enter the user's password; so enter the root password you set in menuconfig. If you forgot to set a password, just use `passwd root` to set a root password.
```bash
ssh root@192.168.1.3
```

## Bonus: Set a Static IP for Pi on Startup using Init Process


## Results
![](./README_Photos/buildroot-drip.png)