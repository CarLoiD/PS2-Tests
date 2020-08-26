APPNAME     = PS2Tests
SHELL       = /bin/sh

TOP         = /usr/local/sce/ee
LIBDIR      = $(TOP)/lib
INCDIR      = $(TOP)/include
GCCDIR      = $(TOP)/gcc/bin

TARGET      = main
OBJS        = crt0.o \
            $(TARGET).o

LCFILE      = $(LIBDIR)/app.cmd
LIBS        = $(LIBDIR)/libgraph.a \
              $(LIBDIR)/libdma.a \
              $(LIBDIR)/libdev.a \
              $(LIBDIR)/libpkt.a \
              $(LIBDIR)/libpad.a \
	      	  $(LIBDIR)/libvu0.a

PREFIX      = ee
AS          = $(GCCDIR)/$(PREFIX)-gcc
CC          = $(GCCDIR)/$(PREFIX)-gcc
LD          = $(GCCDIR)/$(PREFIX)-gcc
DVPASM      = $(GCCDIR)/$(PREFIX)-dvp-as
OBJDUMP     = $(GCCDIR)/$(PREFIX)-objdump
RM          = /bin/rm -f

CFLAGS      = -O2 -Wall -Werror -fno-common -fno-strict-aliasing
CXXFLAGS    = -O2 -Wall -Werror -fno-exceptions -fno-common -fno-strict-aliasing
ASFLAGS     = -c -xassembler-with-cpp
DVPASMFLAGS = 
LDFLAGS     = -mno-crt0 -L$(LIBDIR)
TMPFLAGS    =

RUN         = PCSX2

.SUFFIXES: .c .s .cpp .dsm

all: $(APPNAME).elf

$(APPNAME).elf: $(OBJS) $(LIBS)
	$(LD) -o $@ -T $(LCFILE) $(OBJS) $(LIBS) $(LDFLAGS)

crt0.o: $(LIBDIR)/crt0.s
	$(AS) $(ASFLAGS) $(TMPFLAGS) -o $@ $<

.s.o:
	$(AS) $(ASFLAGS) $(TMPFLAGS) -I$(INCDIR) -o $@ $<

.dsm.o:
	$(DVPASM) $(DVPASMFLAGS) -I$(INCDIR) -o $@ $<

.c.o:
	$(CC) $(CFLAGS) $(TMPFLAGS) -I$(INCDIR) -c $< -o $*.o

.cpp.o:
	$(CC) $(CXXFLAGS) $(TMPFLAGS) -I$(INCDIR) -c $< -o $*.o

clean:
	$(RM) *.o *.map *.lst core *.dis *.elf

run:
	$(RUN) --elf="/home/carloid/Documents/PS2-Tests/$(APPNAME).elf" --nogui --console