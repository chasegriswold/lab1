hello.txt:
	echo "hello world!" > hello.txt

CPP=$(PICO_TOOLCHAIN_PATH)/bin/arm-none-eabi-cpp

#This code changed quite a bit throughout the lab.
#the % maps all files with that extension.
# the $< is for the dependency, the $@ is for the rule.
%.i: %.c
	$(CPP) $< > $@

clean:
	rm -f main.i main.s main.o second.i second.s second.o firmware.elf

#phony is not generating a file for clean, and no file for all, it is not one command clean all.
.PHONY: clean all

CC=$(PICO_TOOLCHAIN_PATH)/bin/arm-none-eabi-gcc
AS=$(PICO_TOOLCHAIN_PATH)/bin/arm-none-eabi-as

%.s: %.i
	$(CC) -S $@

# take every .s file and make a .o file
%.o: %.s
	$(AS) $< -o $@

# # to see what the above does, look to the following: 
# %.o: %.s
# 	$(AS) second.s -o second.o

LD=$(PICO_TOOLCHAIN_PATH)/bin/arm-none-eabi-ld
SRC=main.c second.c
OBJS=$(patsubst %.c,%.o,$(SRC))

firmware.elf: $(OBJS)
	$(LD) -o $@ $^

all: firmware.elf
# This is the long way: (you'd do that every single time, screw that)
# second.o: second.s
# 	$(AS) second.s -o second.o
