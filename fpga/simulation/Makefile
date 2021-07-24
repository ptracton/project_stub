CPU = MOR1KX
TEST_NAME = none
TEST_CASE = $(basename $(TEST_NAME))
TEST_CASE_SRC = $(TEST_CASE).c
TEST_CASE_OBJ = $(TEST_CASE).o
ELF_REQUIREMENTS = $(TEST_CASE_OBJ) 
ELF_FILE  = $(TEST_CASE).elf
LIST_FILE = $(TEST_CASE)_$(CPU).lst
VH_FILE = $(TEST_CASE).vh

FIRMWARE_ROOT = ../firmware
#FIRMWARE_CPU_ROOT = $(FIRMWARE_ROOT)/

BOOT_LIB = $(CPU)boot
BOOT_LIB_DIR = $(FIRMWARE_ROOT)/boot/lib
BOOT_OBJECT =  $(FIRMWARE_ROOT)/boot/objects/crt0.o
BOOT_INC_DIR = $(FIRMWARE_ROOT)/boot/includes

DEVICE_DRIVERS_DIR     = $(FIRMWARE_ROOT)/device_drivers
DEVICE_DRIVERS_INC_DIR = $(DEVICE_DRIVERS_DIR)/includes
DEVICE_DRIVERS_LIB_DIR = $(DEVICE_DRIVERS_DIR)/$(CPU)_lib/
DEVICE_DRIVERS_LIB = $(CPU)_device_drivers

CINCLUDES = -I $(DEVICE_DRIVERS_INC_DIR) -I$(BOOT_INC_DIR)
CFLAGS += -O2 $(CINCLUDES) -g -D$(CPU)  -Wall -Werror -Wextra
LD_FLAGS = -nostdlib -nostartfiles  -T$(FIRMWARE_ROOT)/linker/linker.ld -L $(DEVICE_DRIVERS_LIB_DIR) -l$(DEVICE_DRIVERS_LIB)  -lc -lnosys 
LD_FLAGS += -L $(BOOT_LIB_DIR) -l$(BOOT_LIB)
include $(FIRMWARE_ROOT)/environment.mk

all: $(LIST_FILE) $(VH_FILE)

$(LIST_FILE): $(ELF_FILE)
	@echo "List File: $(LIST_FILE)"
	@$(OBJDUMP) -DSltx  $(ELF_FILE) > $(LIST_FILE)

$(ELF_FILE): $(ELF_REQUIREMENTS)
	@$(MAKE) -C ../firmware/device_drivers CPU=$(CPU)
	@$(MAKE) -C ../firmware/boot CPU=$(CPU)
	@echo "Linking $(ELF_FILE)"
	@$(LD)  $(ELF_REQUIREMENTS)  $(BOOT_OBJECT)  $(LD_FLAGS) -o $(ELF_FILE)

%.vh: %.elf
	@echo "Elf to Verilog Memory Model"
	@$(OBJCOPY) -O srec $< $@.tmp
	@srec_cat $@.tmp -fill 0xFF -within $@.tmp -range-padding 4 --output $@.mem --VMEM 


%.o:%.c
	@echo "Compiling  $<"
	@$(CC) $(CFLAGS) -o $@ -c $< -MMD -MF $(*F).d

clean:
	$(RM) -f $(ELF_FILE) $(TARGET).d $(LIST_FILE) $(TEST_CASE_OBJ) *.bin  *~ $(VH_FILE) $(TEST_CASE).d a.out $(VH_FILE).mem $(VH_FILE).mem.tmp $(VH_FILE).tmp
	@$(MAKE) -C ../firmware/device_drivers CPU=$(CPU) clean
	@$(MAKE) -C ../firmware/boot CPU=$(CPU) clean
