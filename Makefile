# Programs
QUEMU=qemu-system-x86_64
NASM=nasm
CC=/usr/local/i386elfgcc/bin/i386-elf-gcc-12.2.0
LD=/usr/local/i386elfgcc/bin/i386-elf-ld
GDB=/usr/local/i386elfgcc/bin/i386-elf-gdb
# Paths
BIN=bin/
BOOT=src/boot/
KERNEL=src/kernel/
DRIVER=src/driver/
# Flags
NFLAGS=-I$(BOOT)
CFLAGS=-g

all: run

run: $(BIN)os.bin
	$(QUEMU) -drive format=raw,file=$^,index=0,if=floppy, -m 128M

$(BIN)os.bin: $(BIN)boot.bin $(BIN)full_kernel.bin
	cat $^ > $@

$(BIN)boot.bin: $(BOOT)boot.asm
	$(NASM) $(NFLAGS) $^ -f bin -o $@

$(BIN)full_kernel.bin: $(BIN)kernel_entry.o $(BIN)kernel.o
	$(LD) -o $@ -Ttext 0x1000 $^ --oformat binary

$(BIN)kernel.o: $(KERNEL)kernel.c
	$(CC) $(CFLAGS) -ffreestanding -m32 -g -c $^ -o $@

$(BIN)kernel_entry.o: $(KERNEL)kernel_entry.asm
	$(NASM) $^ -f elf -o $@

$(BIN)kernel.elf: $(BIN)kernel_entry.o $(BIN)kernel.o
	$(LD) -o $@ -Ttext 0x1000 $^ 

debug: $(BIN)os.bin $(BIN)kernel.elf
	$(QUEMU) -s -fda $< -S 
#	${GDB} -ex "target remote localhost:1234" -ex "symbol-file $(word 2,$^)"

clean:
	rm -rf bin/*