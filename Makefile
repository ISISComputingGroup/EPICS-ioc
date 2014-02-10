TOP = ../extensions
include $(TOP)/configure/CONFIG
ACTIONS += uninstall

## by default we build all IOCs, but we can remove some here if needed 

# modules not to build on linux
DIRS_NOTBUILD = Makefile README.txt
ifneq ($(findstring linux,$(EPICS_HOST_ARCH)),)
DIRS_NOTBUILD += 
endif
# modules not to build on windows 64bit
ifneq ($(findstring windows,$(EPICS_HOST_ARCH)),)
DIRS_NOTBUILD += 
endif
# modules not to build on windows 32bit
ifneq ($(findstring win32,$(EPICS_HOST_ARCH)),)
DIRS_NOTBUILD += 
endif

# could also check $(STATIC_BUILD) etc if need be

DIRS := $(DIRS) $(filter-out $(DIRS_NOTBUILD), $(wildcard *))

include $(TOP)/configure/RULES_DIRS
