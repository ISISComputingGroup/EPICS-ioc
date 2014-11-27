TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

### NOTE: there should only be one build.mak for a given IOC family and this should be located in the ###-IOC-01 directory

#=============================
# Build the IOC application GALIL-IOC-01
# We actually use $(APPNAME) below so this file can be included by multiple IOCs

PROD_IOC = $(APPNAME)
# GALIL-IOC-01.dbd will be created and installed
DBD += $(APPNAME).dbd

# GALIL-IOC-01.dbd will be made up from these files:
$(APPNAME)_DBD += base.dbd
## ISIS standard dbd ##
$(APPNAME)_DBD += devSequencer.dbd
$(APPNAME)_DBD += icpconfig.dbd
$(APPNAME)_DBD += pvcomplete.dbd 
$(APPNAME)_DBD += pvdump.dbd
$(APPNAME)_DBD += asSupport.dbd
$(APPNAME)_DBD += devIocStats.dbd
$(APPNAME)_DBD += caPutLog.dbd
$(APPNAME)_DBD += utilities.dbd
## add other dbd here ##
$(APPNAME)_DBD += motorSupport.dbd
$(APPNAME)_DBD += motorSimSupport.dbd
$(APPNAME)_DBD += devSoftMotor.dbd
$(APPNAME)_DBD += drvAsynSerialPort.dbd
$(APPNAME)_DBD += drvAsynIPPort.dbd
$(APPNAME)_DBD += busySupport.dbd
$(APPNAME)_DBD += GalilSupport.dbd
$(APPNAME)_DBD += calcSupport.dbd 
$(APPNAME)_DBD += sscanSupport.dbd 
$(APPNAME)_DBD += motionSetPoints.dbd
$(APPNAME)_DBD += sampleChanger.dbd 
$(APPNAME)_DBD += stdSupport.dbd 
$(APPNAME)_DBD += asubFunctions.dbd 

# Add all the support libraries needed by this IOC
## ISIS standard libraries ##
$(APPNAME)_LIBS += seqDev seq pv
$(APPNAME)_LIBS += devIocStats 
$(APPNAME)_LIBS += pvcomplete
$(APPNAME)_LIBS += pvdump $(MYSQLLIB) easySQLite sqlite 
$(APPNAME)_LIBS += caPutLog
$(APPNAME)_LIBS += icpconfig pugixml
$(APPNAME)_LIBS += autosave
$(APPNAME)_LIBS += utilities pcre
## Add other libraries here ##
$(APPNAME)_LIBS += GalilSupport calc sscan
$(APPNAME)_LIBS += motorSimSupport
$(APPNAME)_LIBS += softMotor
$(APPNAME)_LIBS += motor
$(APPNAME)_LIBS += motionSetPoints
$(APPNAME)_LIBS += sampleChanger
$(APPNAME)_LIBS += asubFunctions
$(APPNAME)_LIBS += busy asyn
$(APPNAME)_LIBS += std
$(APPNAME)_LIBS += asubFunctions
$(APPNAME)_LIBS += TinyXML

$(APPNAME)_LIBS += $(EPICS_BASE_IOC_LIBS)

# GALIL-IOC-01_registerRecordDeviceDriver.cpp derives from GALIL-IOC-01.dbd
$(APPNAME)_SRCS += $(APPNAME)_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
$(APPNAME)_SRCS_DEFAULT += $(APPNAME)Main.cpp
$(APPNAME)_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#$(APPNAME)_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
$(APPNAME)_LIBS += $(EPICS_BASE_IOC_LIBS)

ifeq ($(STATIC_BUILD),YES)
$(APPNAME)_LIBS_WIN32 += Galil1 # galil2
$(APPNAME)_SYS_LIBS_WIN32 += delayimp
$(APPNAME)_LDFLAGS_WIN32 += /DELAYLOAD:Galil1.dll
endif

$(APPNAME)_SYS_LIBS_Linux += Galil

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

