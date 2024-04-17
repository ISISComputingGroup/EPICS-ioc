TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

### NOTE: there should only be one build.mak for a given IOC family and this should be located in the ###-IOC-01 directory

#=============================
# Build the IOC application KEPCO-IOC-01
# We actually use $(APPNAME) below so this file can be included by multiple IOCs

PROD_IOC = $(APPNAME)
# KEPCO-IOC-01.dbd will be created and installed
DBD += $(APPNAME).dbd

# KEPCO-IOC-01.dbd will be made up from these files:
$(APPNAME)_DBD += base.dbd
## ISIS standard dbd ##
$(APPNAME)_DBD += icpconfig.dbd
$(APPNAME)_DBD += pvdump.dbd
$(APPNAME)_DBD += calcSupport.dbd
$(APPNAME)_DBD += asyn.dbd
$(APPNAME)_DBD += drvAsynSerialPort.dbd
$(APPNAME)_DBD += drvAsynIPPort.dbd
$(APPNAME)_DBD += stream.dbd
$(APPNAME)_DBD += asSupport.dbd
$(APPNAME)_DBD += devIocStats.dbd
$(APPNAME)_DBD += caPutLog.dbd
$(APPNAME)_DBD += utilities.dbd
$(APPNAME)_DBD += ReadASCII.dbd
$(APPNAME)_DBD += FileList.dbd
$(APPNAME)_DBD += cvtRecord.dbd

## add other dbd here ##
#$(APPNAME)_DBD += xxx.dbd

# Add all the support libraries needed by this IOC
## ISIS standard libraries ##
$(APPNAME)_LIBS += stream ReadASCII FileList
$(APPNAME)_LIBS += asyn cvtRecord csmbase
$(APPNAME)_LIBS += devIocStats
$(APPNAME)_LIBS += caPutLog
$(APPNAME)_LIBS += icpconfig pugixml
$(APPNAME)_LIBS += autosave std calc sscan
$(APPNAME)_LIBS += utilities  libjson zlib efsw pcrecpp pcre
$(APPNAME)_LIBS += pvdump $(MYSQLLIB) easySQLite sqlite
$(APPNAME)_LIBS += seq pv 
## Add other libraries here ##
#$(APPNAME)_LIBS += xxx

# KEPCO-IOC-01_registerRecordDeviceDriver.cpp derives from KEPCO-IOC-01.dbd
$(APPNAME)_SRCS += $(APPNAME)_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
$(APPNAME)_SRCS_DEFAULT += $(APPNAME)Main.cpp
$(APPNAME)_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#$(APPNAME)_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries

# QSRV/PVXS for PVA
ifdef PVXS_MAJOR_VERSION # prefer QSRV2 :)
$(APPNAME)_DBD += pvxsIoc.dbd
$(APPNAME)_LIBS += pvxsIoc pvxs
else
ifdef EPICS_QSRV_MAJOR_VERSION # fallback to QSRV1
$(APPNAME)_LIBS += qsrv
$(APPNAME)_LIBS += $(EPICS_BASE_PVA_CORE_LIBS)
$(APPNAME)_DBD += PVAServerRegister.dbd
$(APPNAME)_DBD += qsrv.dbd
endif
endif


$(APPNAME)_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

