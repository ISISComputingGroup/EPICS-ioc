TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

### NOTE: there should only be one build.mak for a given IOC family and this should be located in the ###-IOC-01 directory

LIBRARY_IOC += instetcSupport
# Compile and add the code to the supporting library
instetcSupport_SRCS += instetcDriver.cpp 
instetcSupport_LIBS += asyn
instetcSupport_LIBS += $(EPICS_BASE_IOC_LIBS)

#=============================
# Build the IOC application INSTETC-IOC-01
# We actually use $(APPNAME) below so this file can be included by multiple IOCs

PROD_IOC = $(APPNAME)
# INSTETC-IOC-01.dbd will be created and installed
DBD += $(APPNAME).dbd
$(APPNAME)_DBD += base.dbd
$(APPNAME)_DBD += asyn.dbd
$(APPNAME)_DBD += devIocStats.dbd
$(APPNAME)_DBD += icpconfig.dbd
$(APPNAME)_DBD += pvdump.dbd
$(APPNAME)_DBD += asSupport.dbd
$(APPNAME)_DBD += caPutLog.dbd
$(APPNAME)_DBD += utilities.dbd
$(APPNAME)_DBD += asubFunctions.dbd
$(APPNAME)_DBD += calcSupport.dbd
$(APPNAME)_DBD += busySupport.dbd
$(APPNAME)_DBD += INSTETCSupport.dbd

# Add all the support libraries needed by this IOC
## ISIS standard libraries ##
$(APPNAME)_LIBS += asubFunctions
$(APPNAME)_LIBS += seq pv
$(APPNAME)_LIBS += devIocStats 
$(APPNAME)_LIBS += pvdump $(MYSQLLIB) easySQLite sqlite 
$(APPNAME)_LIBS += caPutLog
$(APPNAME)_LIBS += icpconfig pugixml
$(APPNAME)_LIBS += autosave
$(APPNAME)_LIBS += utilities pcrecpp pcre
## Add other libraries here ##
$(APPNAME)_LIBS += instetcSupport asyn calc busy sscan

# INSTETC-IOC-01_registerRecordDeviceDriver.cpp derives from INSTETC-IOC-01.dbd
$(APPNAME)_SRCS += $(APPNAME)_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
$(APPNAME)_SRCS_DEFAULT += $(APPNAME)Main.cpp
$(APPNAME)_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#$(APPNAME)_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
include $(CONFIG)/CONFIG_PVA_ISIS

$(APPNAME)_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

