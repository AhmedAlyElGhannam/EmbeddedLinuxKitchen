# Assigning a Static IP to Linux

## Traditional Way of Assigning an IP (Not Static)
```bash
sudo ip a add 192.168.1.3/24 dev enp0s31f6
```

## Via bootargs/Bootcmd
By specifying a network interface and an IP, it can be assigned.
```
ip=192.168.1.2:::::eth0
```

## Via `.profile`
By writing the `ip a add` command in `.profile`, it will be assigned on startup.

## Via a Systemd Service
Create a `.service` file in `/etc/systemd/network/` named `10-static.network` with the following contents:
```systemd
[Match]
Name=eth0

[Network]
Address=192.168.1.100/24
Gateway=192.168.1.1
DNS=8.8.8.8

```

Restart systemd's network daemon:
```bash
sudo systemctl restart systemd-networkd
```

## Via rcS Script
If your init process is SystemV or Busyboxinit, you can either add the line `ip a add ...` to rcS or create a new script altogether and add it to `inittab` file.

```inittab
eth0:::/etc/init.d/staticIP
```