TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

#=============================
# Build the IOC application

PROD_IOC = nanodac
# nanodac.dbd will be created and installed
DBD += nanodac.dbd

# nanodac.dbd will be made up from these files:
nanodac_DBD += base.dbd
nanodac_DBD += asyn.dbd
nanodac_DBD += drvAsynIPPort.dbd
nanodac_DBD += modbusSupport.dbd
nanodac_DBD += busySupport.dbd
nanodac_DBD += devIocStats.dbd
nanodac_DBD += asSupport.dbd

# nanodac_registerRecordDeviceDriver.cpp derives from nanodac.dbd
nanodac_SRCS += nanodac_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
nanodac_SRCS_DEFAULT += nanodacMain.cpp
nanodac_SRCS_vxWorks += -nil-

# Link in the code from the support library
nanodac_LIBS += asyn
nanodac_LIBS += modbus
nanodac_LIBS += busy
nanodac_LIBS += devIocStats
nanodac_LIBS += autosave

# NOTE: To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file

ifneq ($(SNCSEQ),)
    # Build sncExample into nanodacSupport
    sncExample_SNCFLAGS += +r
    nanodac_DBD += sncExample.dbd
    nanodacSupport_SRCS += sncExample.stt
    nanodacSupport_LIBS += seq pv
    nanodac_LIBS += seq pv

    # Build sncProgram as a standalone program
    PROD_HOST += sncProgram
    sncProgram_SNCFLAGS += +m
    sncProgram_SRCS += sncProgram.st
    sncProgram_LIBS += seq pv
    sncProgram_LIBS += $(EPICS_BASE_HOST_LIBS)
endif

# Finally link to the EPICS Base libraries
nanodac_LIBS += $(EPICS_BASE_IOC_LIBS)

#=============================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

