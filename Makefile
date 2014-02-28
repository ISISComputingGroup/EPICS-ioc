TOP = ../extensions
include $(TOP)/configure/CONFIG
ACTIONS += uninstall

## by default we build all IOCs, but we can remove some here if needed

# modules not to build on linux
DIRS_NOTBUILD = Makefile README.txt
ifneq ($(findstring linux,$(EPICS_HOST_ARCH)),)
DIRS_NOTBUILD += ISISDAE
endif
# modules not to build on windows 64bit
ifneq ($(findstring windows,$(EPICS_HOST_ARCH)),)
DIRS_NOTBUILD += 
endif
# modules not to build on windows 32bit
ifneq ($(findstring win32,$(EPICS_HOST_ARCH)),)
DIRS_NOTBUILD += 
endif
# modules not to build if static
ifeq ($(STATIC_BUILD),YES)
DIRS_NOTBUILD += ISISDAE
endif
# modules not to build if shared
ifeq ($(SHARED_LIBRARIES),YES)
DIRS_NOTBUILD += 
endif
# modules not to build if no ATL
ifeq ($(HAVE_ATL),NO)  
DIRS_NOTBUILD += ISISDAE
endif

DIRS := $(DIRS) $(filter-out $(DIRS_NOTBUILD), $(wildcard *))

include $(TOP)/configure/RULES_DIRS
