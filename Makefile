PATHPRJ := $(CURDIR)
NAMEPRJ ?= $(notdir $(PATHPRJ))

PATHSRC ?= .
PATHINC ?= . $(PATHSRC)
PATHBIN ?= ./bin
PATHDEP ?= $(PATHBIN)
PATHOBJ ?= $(PATHBIN)

LISTSRC := $(wildcard $(PATHSRC:%=%/*.s))
LISTSRC += $(wildcard $(PATHSRC:%=%/*.S))
LISTSRC += $(wildcard $(PATHSRC:%=%/*.sx))
LISTSRC += $(wildcard $(PATHSRC:%=%/*.c))
LISTDEP := $(addsuffix .d, $(addprefix $(PATHDEP)/, $(notdir $(basename $(LISTSRC)))))
LISTOBJ := $(addsuffix .o, $(addprefix $(PATHOBJ)/, $(notdir $(basename $(LISTSRC)))))
LISTBIN := $(PATHBIN)/$(NAMEPRJ)

vpath %.s   $(PATHSRC)
vpath %.S   $(PATHSRC)
vpath %.sx  $(PATHSRC)
vpath %.c   $(PATHSRC)
vpath %.inc $(PATHINC)
vpath %.h   $(PATHINC)

# Assembler, compiler and linker:
AS := gcc -S -Wall -Wextra -Wpedantic -Os -std=c99 $(PATHINC:%=-I %) -MMD -MP
CC := gcc -c -Wall -Wextra -Wpedantic -Os -std=c99 $(PATHINC:%=-I %) -MMD -MP
LD := gcc -Os

 # Special targets:
.PHONY: clean clean-all clean-bin clean-obj clean-dep
.PRECIOUS:     $(LISTDEP) $(LISTOBJ)
.SECONDARY:    $(LISTDEP) $(LISTOBJ)
.INTERMEDIATE: $(LISTDEP) $(LISTOBJ)

# Release target:
all: $(LISTBIN)

# Debug target:
debug: AS += -g
debug: CC += -g -D_DEBUG=1
debug: LD += -g
debug: $(LISTBIN)

# Cleanup targets:
clean: clean-bin clean-obj

clean-all: clean-bin clean-obj clean-dep

clean-bin:
	- @ echo 'Cleaning executable files ...'
	- @ rm -f $(LISTBIN)

clean-obj:
	- @ echo 'Cleaning object files ...'
	- @ rm -f $(LISTOBJ)

clean-dep:
	- @ echo 'Cleaning dependency files ...'
	- @ rm -f $(LISTDEP)

# Install target:
install: debug
	@ cp -f $(PATHBIN)/$(NAMEPRJ) ~/bin/

$(PATHOBJ)/%.o: %.s $(MAKEFILE_LIST)
	- @ mkdir -p $(PATHDEP) $(PATHOBJ)
	- @ echo 'Assembling $(<F) ...'
	  @ $(AS) -o $@ -MT $@ -MT $(PATHDEP)/$(@F:.o=.d) -MF $(PATHDEP)/$(@F:.o=.d) $<

$(PATHOBJ)/%.o: %.S $(MAKEFILE_LIST)
	- @ mkdir -p $(PATHDEP) $(PATHOBJ)
	- @ echo 'Assembling $(<F) ...'
	  @ $(AS) -o $@ -MT $@ -MT $(PATHDEP)/$(@F:.o=.d) -MF $(PATHDEP)/$(@F:.o=.d) $<

$(PATHOBJ)/%.o: %.S $(MAKEFILE_LIST)
	- @ mkdir -p $(PATHDEP) $(PATHOBJ)
	- @ echo 'Assembling $(<F) ...'
	  @ $(AS) -o $@ -MT $@ -MT $(PATHDEP)/$(@F:.o=.d) -MF $(PATHDEP)/$(@F:.o=.d) $<

$(PATHOBJ)/%.o: %.c $(MAKEFILE_LIST)
	- @ mkdir -p $(PATHDEP) $(PATHOBJ)
	- @ echo 'Compiling $(<F) ...'
	  @ $(CC) -o $@ -MT $@ -MT $(PATHDEP)/$(@F:.o=.d) -MF $(PATHDEP)/$(@F:.o=.d) $<

$(PATHBIN)/$(NAMEPRJ): $(LISTOBJ)
	- @ mkdir -p $(@D)
	- @ echo 'Linking $(@F) ...'
	  @ $(LD) -o $@ $^

-include $(LISTDEP)
