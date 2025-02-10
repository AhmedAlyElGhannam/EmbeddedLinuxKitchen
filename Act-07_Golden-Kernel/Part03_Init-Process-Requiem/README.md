# Making Dash The `init` Process

## Motivation
So, the kernel boots successfully but it panics because it cannot find the init process. 

Then it hit me: why not build a simple shell and use it as the init process?

The first choice was to NOT use bash since it is waaaay too complicated to build for such an experiment. After some research, I have found a shell called `dash` that is simple enough to build and use.

## Building Dash
To start things off, clone the `dash` repository.
```bash
git clone https://github.com/danishprakash/dash.git
```

Then, cross-build it for the Raspberry Pi 3B+.
```make
aarch64-rpi3-linux-gnu-gcc dash.c -static -Wall -o init
```

The result is a petite binary that can be transfered to your sd card to use it as the init process.

## Modifying Bootargs
The only step that remains is to modify the bootargs and specify the location of the init process.
```
init=/init
```