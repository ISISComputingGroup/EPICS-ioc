TOP = ../../extensions/master
include $(TOP)/configure/CONFIG

## list all valid IOC directories that we may want to build at some point
IOCDIRS = AG33220A AG3631A AG53220A CONEXAGP CONTROLSVCS CRYVALVE DELFTARDUSTEP DELFTBPMAG DELFTDCMAG DELFTSHEAR DFKPS ECLAB EUROTHERM FINS GALIL HAMEG8123 HVCAEN INSTETC ISISDAE JULABO KEPCO LINKAM95 LKSH218 LKSH336 MCLEN MERCURY_ITC MK3CHOPPER PDR2000 PIMOT PSCTRL RUNCTRL SDTEST SKFCHOPPER SMC100 SPINFLIPPER306015 STPS350 STSR400 TDK_LAMBDA_GENESYS TEKAFG3XXX TEKDMM40X0 TEKMSO4104B TEST TPG26x TPG300 TTIEX355P 

## modules not to build on linux
ifneq ($(findstring linux,$(EPICS_HOST_ARCH)),)
DIRS_NOTBUILD += MK3CHOPPER ECLAB GALIL 
endif

## modules not to build on windows 64bit
ifneq ($(findstring windows,$(EPICS_HOST_ARCH)),)
DIRS_NOTBUILD += 
# don't build the mk3chopper if not using VS2010
ifeq ($(findstring 10.0,$(VCVERSION)),)
DIRS_NOTBUILD += MK3CHOPPER
endif
endif

## modules not to build on windows 32bit
ifneq ($(findstring win32,$(EPICS_HOST_ARCH)),)
DIRS_NOTBUILD += ISISDAE MK3CHOPPER
endif

## modules not to build if static
ifeq ($(STATIC_BUILD),YES)
DIRS_NOTBUILD += ISISDAE GALIL
endif

## modules not to build if shared
ifeq ($(SHARED_LIBRARIES),YES)
DIRS_NOTBUILD += 
endif

## modules not to build if no Windows ATL present (depends on Visual Studio compiler)  
ifneq ($(HAVE_ATL),YES)  
DIRS_NOTBUILD += ISISDAE MERCURY_ITC STPS350 AG53220A STSR400 DELFTSHEAR DELFTDCMAG DELFTARDUSTEP LVTEST
endif

DIRS := $(filter-out $(DIRS_NOTBUILD), $(IOCDIRS))

include $(TOP)/configure/RULES_DIRS_INT
