TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

### NOTE: there should only be one build.mak for a given IOC family and this should be located in the ###-IOC-01 directory

#CAENHVWRAPPER=$(HVCAEN)/HVCAENx527App/src/CAENHVWrapper
#ifneq ($(findstring win32-x86,$(EPICS_HOST_ARCH)),)
#CAEN_ARCH=win32
#endif
#ifneq ($(findstring windows-x64,$(EPICS_HOST_ARCH)),)
#CAEN_ARCH=win64
#endif
#ifneq ($(findstring linux,$(EPICS_HOST_ARCH)),) 
#USR_LDFLAGS += -L$(CAENHVWRAPPER)/lib/$(EPICS_HOST_ARCH)
#endif
#USR_INCLUDES += -I$(CAENHVWRAPPER)/include
caenhvwrapper_DIR = $(HVCAEN)/lib/$(EPICS_HOST_ARCH)
hscaenetlib_DIR = $(HVCAEN)/lib/$(EPICS_HOST_ARCH)

#=============================
# Build the IOC application HVCAEN-IOC-01
# We actually use $(APPNAME) below so this file can be included by multiple IOCs

PROD_IOC = $(APPNAME)
# HVCAEN-IOC-01.dbd will be created and installed
DBD += $(APPNAME).dbd

# HVCAEN-IOC-01.dbd will be made up from these files:
$(APPNAME)_DBD += base.dbd
## ISIS standard dbd ##
$(APPNAME)_DBD += devSequencer.dbd
$(APPNAME)_DBD += icpconfig.dbd
$(APPNAME)_DBD += pvdump.dbd
$(APPNAME)_DBD += asSupport.dbd
$(APPNAME)_DBD += devIocStats.dbd
$(APPNAME)_DBD += caPutLog.dbd
$(APPNAME)_DBD += utilities.dbd
## add other dbd here ##
$(APPNAME)_DBD += HVCAENx527.dbd

# Add all the support libraries needed by this IOC
## Add other libraries here ##
$(APPNAME)_LIBS += HVCAENx527 HVCAENx527Summary
## ISIS standard libraries ##
$(APPNAME)_LIBS += asubFunctions
$(APPNAME)_LIBS += seqDev seq pv
$(APPNAME)_LIBS += devIocStats 
$(APPNAME)_LIBS += pvdump $(MYSQLLIB) easySQLite sqlite 
$(APPNAME)_LIBS += caPutLog
$(APPNAME)_LIBS += icpconfig pugixml
$(APPNAME)_LIBS += autosave
$(APPNAME)_LIBS += utilities pcre
$(APPNAME)_LIBS_WIN32 += caenhvwrapper # hscaenetlib
$(APPNAME)_SYS_LIBS_Linux += caenhvwrapper hscaenetlib

# HVCAEN-IOC-01_registerRecordDeviceDriver.cpp derives from HVCAEN-IOC-01.dbd
$(APPNAME)_SRCS += $(APPNAME)_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
$(APPNAME)_SRCS_DEFAULT += $(APPNAME)Main.cpp
$(APPNAME)_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#$(APPNAME)_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
$(APPNAME)_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
