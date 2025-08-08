PREFIX	?= arm-none-eabi
CC		= $(PREFIX)-gcc-14.2.1
LD		= $(PREFIX)-gcc-14.2.1
OPENCM3_DIR = ../libopencm3
PCG_DIR = ../pcg-c-basic

LDSCRIPT   = stm32f405x6_CCM.ld
LIBNAME    = opencm3_stm32f4
ARCH_FLAGS = -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16
DEFINES    = -DSTM32F4 -DCORTEX_M4 -D__thumb__
OBJS	   = uECC.o $(PCG_DIR)/pcg_basic.o


CFLAGS		+= -g -O2 \
		   -Wall -Wextra -Wimplicit-function-declaration \
		   -Wredundant-decls -Wmissing-prototypes -Wstrict-prototypes \
		   -Wundef -Wshadow \
		   -I$(OPENCM3_DIR)/include -I$(PCG_DIR) \
		   -fno-common $(ARCH_FLAGS) -ffunction-sections -fdata-sections -MD $(DEFINES)
LDFLAGS		+= --static -Wl,--start-group -Wl,--strip-debug -lc -lgcc -lnosys -Wl,--end-group \
		   -T$(LDSCRIPT) -nostartfiles -Wl,--gc-sections,--print-gc-sections \
		   $(ARCH_FLAGS) \
		   -L$(OPENCM3_DIR)/lib -L$(PCG_DIR)

-include local.mk

all: eval.elf

lib:
	make -C $(OPENCM3_DIR)

pcg:
	make -C $(PCG_DIR)

%.elf: %.o $(OBJS) $(LDSCRIPT)
	$(LD) -o $(*).elf $(*).o $(OBJS) $(LDFLAGS) -l$(LIBNAME)

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

clean:
	find . -name \*.o -type f -exec rm -f {} \;
	find . -name \*.d -type f -exec rm -f {} \;
	rm -f *.elf
	rm -f *.bin

