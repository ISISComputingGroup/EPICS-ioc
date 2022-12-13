TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

### NOTE: there should only be one build.mak for a given IOC family and this should be located in the ###-IOC-01 directory

#=============================
# Build the IOC application TC-IOC-01
# We actually use $(APPNAME) below so this file can be included by multiple IOCs

PROD_IOC = $(APPNAME)
# TC-IOC-01.dbd will be created and installed
DBD += $(APPNAME).dbd

# TC-IOC-01.dbd will be made up from these files:
$(APPNAME)_DBD += base.dbd
## ISIS standard dbd ##
$(APPNAME)_DBD += icpconfig.dbd
$(APPNAME)_DBD += pvdump.dbd
$(APPNAME)_DBD += asSupport.dbd
$(APPNAME)_DBD += devIocStats.dbd
$(APPNAME)_DBD += caPutLog.dbd
$(APPNAME)_DBD += utilities.dbd
$(APPNAME)_DBD += system.dbd

## Stream device support ##

$(APPNAME)_DBD += calcSupport.dbd
## add other dbd here ##
$(APPNAME)_DBD += asyn.dbd
$(APPNAME)_DBD += motionSetPoints.dbd
$(APPNAME)_DBD += motorSupport.dbd
$(APPNAME)_DBD += motorSimSupport.dbd
$(APPNAME)_DBD += devSoftMotor.dbd
$(APPNAME)_DBD += tcIocSupport.dbd
$(APPNAME)_DBD += tcIocMotorSupport.dbd
$(APPNAME)_DBD += luaSupport.dbd
$(APPNAME)_DBD += asubFunctions.dbd 


# Add all the support libraries needed by this IOC

USR_DBDFLAGS += -I$(TCIOC)/InfoDeviceSupport -I$(TCIOC)/TCatDeviceSupport

## ISIS standard libraries ##
## Stream device libraries ##
$(APPNAME)_LIBS += asubFunctions
$(APPNAME)_LIBS += tcIocSupport
$(APPNAME)_LIBS += tcIocMotorSupport
$(APPNAME)_LIBS += softMotor 
$(APPNAME)_LIBS += motorSimSupport
$(APPNAME)_LIBS += motor
$(APPNAME)_LIBS += stream
$(APPNAME)_LIBS += lua
$(APPNAME)_LIBS += asyn
$(APPNAME)_LIBS += motionSetPoints
## other standard libraries here ##
$(APPNAME)_LIBS += devIocStats 
$(APPNAME)_LIBS += pvdump $(MYSQLLIB) easySQLite sqlite 
$(APPNAME)_LIBS += caPutLog
$(APPNAME)_LIBS += icpconfig
$(APPNAME)_LIBS += autosave
$(APPNAME)_LIBS += utilities pugixml libjson zlib
$(APPNAME)_LIBS += calc sscan
$(APPNAME)_LIBS += pcrecpp pcre
$(APPNAME)_LIBS += seq pv

# TC-IOC-01_registerRecordDeviceDriver.cpp derives from TC-IOC-01.dbd
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

