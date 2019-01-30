TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

### NOTE: there should only be one build.mak for a given IOC family and this should be located in the ###-IOC-01 directory

#=============================
# Build the IOC application ASTRIUM-IOC-01
# We actually use $(APPNAME) below so this file can be included by multiple IOCs

PROD_IOC = $(APPNAME)
# ASTRIUM-IOC-01.dbd will be created and installed
DBD += $(APPNAME).dbd

# ASTRIUM-IOC-01.dbd will be made up from these files:
$(APPNAME)_DBD += $(TOP)/ASTRIUM-IOC-01App/src/astriumInclude.dbd

# Add all the support libraries needed by this IOC
## ISIS standard libraries ##
$(APPNAME)_LIBS += pv
$(APPNAME)_LIBS += devIocStats 
$(APPNAME)_LIBS += pvdump $(MYSQLLIB) easySQLite sqlite 
$(APPNAME)_LIBS += caPutLog
$(APPNAME)_LIBS += icpconfig pugixml
$(APPNAME)_LIBS += autosave
$(APPNAME)_LIBS += utilities
$(APPNAME)_LIBS += sscan
## Add other libraries here ##
$(APPNAME)_LIBS += asyn AstriumBridgeLib
$(APPNAME)_LIBS += stream calc pcre

# ASTRIUM-IOC-01_registerRecordDeviceDriver.cpp derives from ASTRIUM-IOC-01.dbd
$(APPNAME)_SRCS += $(APPNAME)_registerRecordDeviceDriver.cpp astriumDriver.cpp astriumInterface.cpp
SRC_DIRS += $(TOP)/ASTRIUM-IOC-01App/src
# Build the main IOC entry point on workstation OSs.
$(APPNAME)_SRCS_DEFAULT += $(APPNAME)Main.cpp 
$(APPNAME)_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#$(APPNAME)_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
$(APPNAME)_LIBS += $(EPICS_BASE_IOC_LIBS)

BIN_INSTALLS_WIN32 += $(wildcard $(SUPPORT)/astriumchopper/master/bin/$(EPICS_HOST_ARCH)/*.dll)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

