TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

### NOTE: there should only be one build.mak for a given IOC family and this should be located in the ###-IOC-01 directory

#=============================
# Build the IOC application ISISDAE-IOC-01
# We actually use $(APPNAME) below so this file can be included by multiple IOCs

ifeq ($(STATIC_BUILD),NO)
PROD_IOC_WIN32 = $(APPNAME)
endif
# ISISDAE-IOC-01.dbd will be created and installed
DBD += $(APPNAME).dbd

PROD_NAME = $(APPNAME)
include $(ADCORE)/ADApp/commonDriverMakefile

# ISISDAE-IOC-01.dbd will be made up from these files:
# we get base, asyn + areadetetor standard plugins as part of commonDriverMakefile include
## ISIS standard dbd ##
$(APPNAME)_DBD += icpconfig.dbd
$(APPNAME)_DBD += pvdump.dbd
$(APPNAME)_DBD += caPutLog.dbd
$(APPNAME)_DBD += utilities.dbd
$(APPNAME)_DBD += asubFunctions.dbd 
## add other dbd here ##
$(APPNAME)_DBD += isisdae.dbd
$(APPNAME)_DBD += webget.dbd
$(APPNAME)_DBD += FileList.dbd
$(APPNAME)_DBD += ADnEDSupport.dbd
$(APPNAME)_DBD += ffmpegServer.dbd

# Add all the support libraries needed by this IOC
## ISIS standard libraries ##
$(APPNAME)_LIBS += asubFunctions
$(APPNAME)_LIBS += webget htmltidy
$(APPNAME)_LIBS += seq pv
$(APPNAME)_LIBS += devIocStats 
$(APPNAME)_LIBS += pvdump $(MYSQLLIB) easySQLite sqlite 
$(APPNAME)_LIBS += caPutLog
$(APPNAME)_LIBS += icpconfig pugixml
$(APPNAME)_LIBS += autosave
$(APPNAME)_LIBS += utilities
$(APPNAME)_LIBS += asubFunctions
## Add other libraries here ##
$(APPNAME)_LIBS += FileList isisdae asyn oncrpc zlib efsw pcrecpp pcre cas gdd
$(APPNAME)_LIBS += ffmpegServer
$(APPNAME)_LIBS += avdevice
$(APPNAME)_LIBS += avformat
$(APPNAME)_LIBS += avcodec
$(APPNAME)_LIBS += avutil
$(APPNAME)_LIBS += swscale
$(APPNAME)_LIBS += ADnEDSupport
$(APPNAME)_LIBS += ADnEDTransform

# ISISDAE-IOC-01_registerRecordDeviceDriver.cpp derives from ISISDAE-IOC-01.dbd
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

