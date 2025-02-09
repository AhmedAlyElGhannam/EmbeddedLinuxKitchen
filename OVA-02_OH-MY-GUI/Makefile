CC=aarch64-rpi3-linux-gnu-gcc
INC_DIR = ./inc/
LIB_DIR = ./lib/
SRC = ./src/gui.c
MWIMG_LIB = mwimages 
MWIN_LIB = mwin
NX11_LIB = NX11
TARGET = build/gui.elf
FLAG = -static

all:
	$(CC) -c $(SRC) -I$(INC_DIR) -L$(LIB_DIR) -l$(MWIMG_LIB) -l$(MWIN_LIB) -l$(NX11_LIB) -o $(TARGET) $(FLAG)
	#@chmod +x $(TARGET)
clean:
	rm $(TARGET)
