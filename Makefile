VERSION = 1
PATCHLEVEL = 0
SUBLEVEL = 0
NAME = "Bday Edition"

CROSS_COMPILE = arm-arago-linux-gnueabi-

CC = ${CROSS_COMPILE}gcc
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJFMT	= binary

SRCDIR = src
BINDIR = bin

INCLUDES = $(SRCDIR)/include
CFLAGS =-mcpu=cortex-m3 -mthumb -nostdlib -Wall -Wundef \
	-Werror-implicit-function-declaration -Wstrict-prototypes \
	-Wdeclaration-after-statement -fno-delete-null-pointer-checks \
	-Wempty-body -fno-strict-overflow  -g -I$(INCLUDES) -O2
LDFLAGS =-nostartfiles -fno-exceptions -Tfirmware.ld

EXECUTABLE=am335x-pm-firmware.elf

.PHONY: all clean

SOURCES = $(shell find $(SRCDIR) -name *.c)
OBJECTS = $(SOURCES:.c=.o)

#
# Pretty print
#
V             = @
Q             = $(V:1=)
QUIET_CC      = $(Q:@=@echo    '     CC       '$@;)
QUIET_GEN     = $(Q:@=@echo    '     GEN      '$@;)
QUIET_LINK    = $(Q:@=@echo    '     LINK     '$@;)

.c.o:
	$(QUIET_CC) $(CC) $(CFLAGS) $(LDFLAGS) -c $< -o $@

$(EXECUTABLE): $(OBJECTS)
	$(QUIET_LINK) $(CC) $(CFLAGS) $(LDFLAGS) $(OBJECTS) -o $(BINDIR)/$@

all: $(EXECUTABLE)
	$(QUIET_GEN) $(OBJCOPY) -O$(OBJFMT) $(BINDIR)/$(EXECUTABLE) \
		$(BINDIR)/$(EXECUTABLE:.elf=.bin)

clean:
	@echo "Cleaning up..."
	-$(shell find . -name *.o -exec rm {} \;)
	-$(shell rm -f $(BINDIR)/$(EXECUTABLE))
	-$(shell rm -f $(BINDIR)/$(EXECUTABLE:.elf=.bin))
	@echo "Done!"
