TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

### NOTE: there should only be one build.mak for a given IOC family and this should be located in the ###-IOC-01 directory

#=============================
# Build the IOC application SEPRTR-IOC-01
# We actually use $(APPNAME) below so this file can be included by multiple IOCs

PROD_IOC = $(APPNAME)
# SEPRTR-IOC-01.dbd will be created and installed
DBD += $(APPNAME).dbd

# SEPRTR-IOC-01.dbd will be made up from these files:
$(APPNAME)_DBD += base.dbd
## ISIS standard dbd ##
$(APPNAME)_DBD += icpconfig.dbd
$(APPNAME)_DBD += pvdump.dbd
$(APPNAME)_DBD += asSupport.dbd
$(APPNAME)_DBD += devIocStats.dbd
$(APPNAME)_DBD += caPutLog.dbd
$(APPNAME)_DBD += utilities.dbd
## Stream device support ##
$(APPNAME)_DBD += calcSupport.dbd
$(APPNAME)_DBD += asyn.dbd
$(APPNAME)_DBD += drvAsynSerialPort.dbd
$(APPNAME)_DBD += drvAsynIPPort.dbd
$(APPNAME)_DBD += stream.dbd
$(APPNAME)_DBD += DAQmxSupport.dbd
## add other dbd here ##
$(APPNAME)_DBD += separator.dbd

# Add all the support libraries needed by this IOC
## ISIS standard libraries ##
$(APPNAME)_LIBS += SEPRTR
$(APPNAME)_LIBS += DAQmxSupport
$(APPNAME)_LIBS += devIocStats 
$(APPNAME)_LIBS += pvdump $(MYSQLLIB) easySQLite sqlite 
$(APPNAME)_LIBS += caPutLog
$(APPNAME)_LIBS += icpconfig pugixml
$(APPNAME)_LIBS += autosave
## Stream device libraries ##
$(APPNAME)_LIBS += stream
$(APPNAME)_LIBS += asyn
## Add other libraries here ##
$(APPNAME)_LIBS += utilities pcrecpp pcre libjson zlib
$(APPNAME)_LIBS += calc sscan
$(APPNAME)_LIBS += seq pv
#$(APPNAME)_LIBS += xxx
# SEPRTR-IOC-01_registerRecordDeviceDriver.cpp derives from SEPRTR-IOC-01.dbd
$(APPNAME)_SRCS += $(APPNAME)_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
$(APPNAME)_SRCS_DEFAULT += $(APPNAME)Main.cpp
$(APPNAME)_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#$(APPNAME)_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
## area detector already includes PVA, so avoid including it twice
ifeq ($(AREA_DETECTOR),)
include $(CONFIG)/CONFIG_PVA_ISIS
endif

$(APPNAME)_LIBS += $(EPICS_BASE_IOC_LIBS)

# daqmx external library (need to specify explicitly for static buulds)
ifneq ($(findstring windows,$(EPICS_HOST_ARCH)),)
DAQMXLIB = $(ICPBINARYDIR)/NIDAQmx/lib/msvc64
else
DAQMXLIB = $(ICPBINARYDIR)/NIDAQmx/lib/msvc
endif
$(APPNAME)_SYS_LIBS_WIN32 += $(DAQMXLIB)/NIDAQmx


$(APPNAME)_SYS_LIBS_Linux += nidaqmx
$(APPNAME)_LDFLAGS_Linux += -L/usr/lib/x86_64-linux-gnu
#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

