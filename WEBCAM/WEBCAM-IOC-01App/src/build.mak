TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

### NOTE: there should only be one build.mak for a given IOC family and this should be located in the ###-IOC-01 directory

#=============================
# Build the IOC application WEBCAM-IOC-01
# We actually use $(APPNAME) below so this file can be included by multiple IOCs

PROD_IOC = $(APPNAME)
# WEBCAM-IOC-01.dbd will be created and installed
DBD += $(APPNAME).dbd

PROD_NAME = $(APPNAME)
include $(ADCORE)/ADApp/commonDriverMakefile

# WEBCAM-IOC-01.dbd will be made up from these files:
# we get base, asyn + areadetetor standard plugins as part of commonDriverMakefile include
## ISIS standard dbd ##
$(APPNAME)_DBD += icpconfig.dbd
$(APPNAME)_DBD += pvdump.dbd
$(APPNAME)_DBD += asSupport.dbd
$(APPNAME)_DBD += devIocStats.dbd
$(APPNAME)_DBD += caPutLog.dbd
$(APPNAME)_DBD += utilities.dbd
$(APPNAME)_DBD += asubFunctions.dbd 
## Stream device support ##
$(APPNAME)_DBD += calcSupport.dbd
$(APPNAME)_DBD += asyn.dbd
$(APPNAME)_DBD += drvAsynSerialPort.dbd
$(APPNAME)_DBD += drvAsynIPPort.dbd
$(APPNAME)_DBD += luaSupport.dbd
$(APPNAME)_DBD += webget.dbd
#not on linux
#$(APPNAME)_DBD += ffmpegServer.dbd
$(APPNAME)_DBD += URLDriverSupport.dbd
## add other dbd here ##
#$(APPNAME)_DBD += xxx.dbd

# Add all the support libraries needed by this IOC

## Add additional libraries here ##
#$(APPNAME)_LIBS += xxx

## ISIS standard libraries ##
## Stream device libraries ##
$(APPNAME)_LIBS += webget htmltidy
$(APPNAME)_LIBS += lua
$(APPNAME)_LIBS += asyn

## other standard libraries here ##

$(APPNAME)_LIBS += URLDriver

#not on linux
#$(APPNAME)_LIBS += ffmpegServer
#$(APPNAME)_LIBS += avdevice
#$(APPNAME)_LIBS += avformat
#$(APPNAME)_LIBS += avcodec
#$(APPNAME)_LIBS += avutil
#$(APPNAME)_LIBS += swscale

$(APPNAME)_LIBS += devIocStats 
$(APPNAME)_LIBS += pvdump $(MYSQLLIB) easySQLite sqlite 
$(APPNAME)_LIBS += caPutLog
$(APPNAME)_LIBS += icpconfig
$(APPNAME)_LIBS += autosave
$(APPNAME)_LIBS += utilities pugixml libjson zlib
$(APPNAME)_LIBS += asubFunctions
$(APPNAME)_LIBS += calc sscan
$(APPNAME)_LIBS += pcrecpp pcre
$(APPNAME)_LIBS += seq pv

$(APPNAME)_LIBS_WIN32 += libcurl oncrpc
$(APPNAME)_SYS_LIBS_Linux += curl

$(APPNAME)_LIBS_WIN32 += ssleay32 libeay32

$(APPNAME)_SYS_LIBS_WIN32 += psapi wldap32 ws2_32 crypt32 Normaliz # advapi32 user32 msxml2

# WEBCAM-IOC-01_registerRecordDeviceDriver.cpp derives from WEBCAM-IOC-01.dbd
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

