VERSIONS := 6_72 7_02 7_55 9_00
VRAM_SIZES := 1 2 3 4 5

all: CreateDir $(foreach ver,$(VERSIONS),$(foreach size,$(VRAM_SIZES),LinuxLoader-$(ver)-$(size)gb.bin)) cleanelf

clean:
	rm -rf build
	cd lib; make clean
	cd src; make clean

cleanelf:
	cd build; rm -f *.elf

CreateDir:
	mkdir -p build

define compile_version
lib/lib-$(1).a:
	@echo Compiling lib.a for $(1)
	@echo
	cd lib && $(MAKE) PS4_VERSION=$(1)
	mv lib/lib.a lib/lib-$(1).a
	@echo
	@echo lib-$(1).a compiled
	@echo

src/kexec-$(1).bin:
	@echo Compiling kexec.bin for $(1)
	@echo
	cd src && $(MAKE) PS4_VERSION=$(1)
	mv src/kexec.bin src/kexec-$(1).bin
	@echo
	@echo kexec-$(1).bin compiled
	@echo

LinuxLoader-$(1).elf: lib/lib-$(1).a main.c src/kexec-$(1).bin
	gcc -isystem freebsd-headers -nostdinc -nostdlib -fno-stack-protector -static lib/lib-$(1).a -D__$(1)__ main.c -Wl,-gc-sections -o build/LinuxLoader-$(1).elf -fPIE -ffreestanding

LinuxLoader-$(1).bin: LinuxLoader-$(1).elf
	objcopy build/LinuxLoader-$(1).elf --only-section .text --only-section .data --only-section .bss --only-section .rodata -O binary build/LinuxLoader-$(1).bin
	file build/LinuxLoader-$(1).bin | fgrep -q 'LinuxLoader-$(1).bin: DOS executable (COM)'

LinuxLoader-$(1)-1gb.elf: lib/lib-$(1).a main.c src/kexec-$(1).bin
	gcc -isystem freebsd-headers -nostdinc -nostdlib -fno-stack-protector -static lib/lib-$(1).a -DVRAM_GB_DEFAULT=1 -D__$(1)__ main.c -Wl,-gc-sections -o build/LinuxLoader-$(1)-1gb.elf -fPIE -ffreestanding

LinuxLoader-$(1)-1gb.bin: LinuxLoader-$(1)-1gb.elf
	objcopy build/LinuxLoader-$(1)-1gb.elf --only-section .text --only-section .data --only-section .bss --only-section .rodata -O binary build/LinuxLoader-$(1)-1gb.bin
	file build/LinuxLoader-$(1)-1gb.bin | fgrep -q 'LinuxLoader-$(1)-1gb.bin: DOS executable (COM)'

LinuxLoader-$(1)-2gb.elf: lib/lib-$(1).a main.c src/kexec-$(1).bin
	gcc -isystem freebsd-headers -nostdinc -nostdlib -fno-stack-protector -static lib/lib-$(1).a -DVRAM_GB_DEFAULT=2 -D__$(1)__ main.c -Wl,-gc-sections -o build/LinuxLoader-$(1)-2gb.elf -fPIE -ffreestanding

LinuxLoader-$(1)-2gb.bin: LinuxLoader-$(1)-2gb.elf
	objcopy build/LinuxLoader-$(1)-2gb.elf --only-section .text --only-section .data --only-section .bss --only-section .rodata -O binary build/LinuxLoader-$(1)-2gb.bin
	file build/LinuxLoader-$(1)-2gb.bin | fgrep -q 'LinuxLoader-$(1)-2gb.bin: DOS executable (COM)'

LinuxLoader-$(1)-3gb.elf: lib/lib-$(1).a main.c src/kexec-$(1).bin
	gcc -isystem freebsd-headers -nostdinc -nostdlib -fno-stack-protector -static lib/lib-$(1).a -DVRAM_GB_DEFAULT=3 -D__$(1)__ main.c -Wl,-gc-sections -o build/LinuxLoader-$(1)-3gb.elf -fPIE -ffreestanding

LinuxLoader-$(1)-3gb.bin: LinuxLoader-$(1)-3gb.elf
	objcopy build/LinuxLoader-$(1)-3gb.elf --only-section .text --only-section .data --only-section .bss --only-section .rodata -O binary build/LinuxLoader-$(1)-3gb.bin
	file build/LinuxLoader-$(1)-3gb.bin | fgrep -q 'LinuxLoader-$(1)-3gb.bin: DOS executable (COM)'

LinuxLoader-$(1)-4gb.elf: lib/lib-$(1).a main.c src/kexec-$(1).bin
	gcc -isystem freebsd-headers -nostdinc -nostdlib -fno-stack-protector -static lib/lib-$(1).a -DVRAM_GB_DEFAULT=4 -D__$(1)__ main.c -Wl,-gc-sections -o build/LinuxLoader-$(1)-4gb.elf -fPIE -ffreestanding

LinuxLoader-$(1)-4gb.bin: LinuxLoader-$(1)-4gb.elf
	objcopy build/LinuxLoader-$(1)-4gb.elf --only-section .text --only-section .data --only-section .bss --only-section .rodata -O binary build/LinuxLoader-$(1)-4gb.bin
	file build/LinuxLoader-$(1)-4gb.bin | fgrep -q 'LinuxLoader-$(1)-4gb.bin: DOS executable (COM)'

LinuxLoader-$(1)-5gb.elf: lib/lib-$(1).a main.c src/kexec-$(1).bin
	gcc -isystem freebsd-headers -nostdinc -nostdlib -fno-stack-protector -static lib/lib-$(1).a -DVRAM_GB_DEFAULT=5 -D__$(1)__ main.c -Wl,-gc-sections -o build/LinuxLoader-$(1)-5gb.elf -fPIE -ffreestanding

LinuxLoader-$(1)-5gb.bin: LinuxLoader-$(1)-5gb.elf
	objcopy build/LinuxLoader-$(1)-5gb.elf --only-section .text --only-section .data --only-section .bss --only-section .rodata -O binary build/LinuxLoader-$(1)-5gb.bin
	file build/LinuxLoader-$(1)-5gb.bin | fgrep -q 'LinuxLoader-$(1)-5gb.bin: DOS executable (COM)'

endef

$(foreach ver,$(VERSIONS),$(eval $(call compile_version,$(ver))))

.PHONY: clean cleanelf