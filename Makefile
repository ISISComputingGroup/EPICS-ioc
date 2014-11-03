TOP = ../extensions
include $(TOP)/configure/CONFIG

## by default we build all IOCs, but we can remove some here if needed

DIRS_NOTBUILD = Makefile README.txt icp_config.xml icp_config.template.xml isisicp.properties isisicp.default.properties 
DIRS_NOTBUILD += NULL # this file seems to get created occasionally 
# modules not to build on linux
ifneq ($(findstring linux,$(EPICS_HOST_ARCH)),)
DIRS_NOTBUILD += ISISDAE MK3CHOPPER STPS350 AG53220A STSR400
endif
# modules not to build on windows 64bit
ifneq ($(findstring windows,$(EPICS_HOST_ARCH)),)
DIRS_NOTBUILD += 
endif
# modules not to build on windows 32bit
ifneq ($(findstring win32,$(EPICS_HOST_ARCH)),)
DIRS_NOTBUILD += ISISDAE
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
ifneq ($(HAVE_ATL),YES)  
DIRS_NOTBUILD += ISISDAE STPS350 AG53220A STSR400
endif

DIRS := $(DIRS) $(filter-out $(DIRS_NOTBUILD), $(wildcard *))

include $(TOP)/configure/RULES_DIRS_INT
