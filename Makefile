TOP = ../../extensions/master
include $(TOP)/configure/CONFIG

ifneq ($(findstring static,$(EPICS_HOST_ARCH)),)
BUILDING_SHARED=NO
else
BUILDING_SHARED=YES
endif

## list all valid IOC directories that we may want to build at some point
IOCDIRS = AG33220A ASTRIUM CCD100 CONEXAGP CONTROLSVCS CRYVALVE DELFTARDUSTEP DELFTBPMAG DELFTDCMAG DELFTSHEAR DFKPS ECLAB EUROTHRM FINS GALIL GALIL-OLD GALIL-NEW
IOCDIRS += HAMEG8123 HLG HVCAEN INHIBITR INSTETC INSTRON ISISDAE JULABO KHLY2400 KEPCO LINKAM95 LINMOT LKSH218 LKSH336 
IOCDIRS += MCLEN MERCURY_ITC MK2CHOPR MK3CHOPR MUONJAWS NANODAC NEOCERA PDR2000 PIMOT PSCTRL 
IOCDIRS += RUNCTRL SCIMAG3D SDTEST SKFCHOPPER SMC100 SPINFLIPPER306015 TDK_LAMBDA_GENESYS TEKAFG3XXX TEKDMM40X0 TEKMSO4104B TEST TPG26x TPG300 TTIEX355P
IOCDIRS += ROTSC AMINT2L SPRLG FERMCHOP SAMPOS CYBAMAN EGXCOLIM IEG LKSH460 SKFMB350 SECI2IBEX
IOCDIRS += GEMORC SM300 FZJDDFCH TRITON ILM200 SCHNDR GAMRY KHLY2700 COUETTE ITC503 IPS
IOCDIRS += SP2XX RKNDIO NGPSPSU KYNCTM3K INDFURN SEPRTR DMA4500M QEPRO KHLY2001 WBVALVE WM323
IOCDIRS += KNR1050 TTIPLP DH2000 MOXA12XX JSCO4180 MEZFLIPR DETADC
IOCDIRS += TTI355
IOCDIRS += KNRK6 NGEM NIMATRO LKSH340 TPG36x CAENMCA ALDN1000
IOCDIRS += CP2800
IOCDIRS += CHTOBISR KEYLKG
IOCDIRS += HELIOX
IOCDIRS += TC
IOCDIRS += MKSPR4KB
IOCDIRS += OERCONE
IOCDIRS += EDTIC
IOCDIRS += CRYOSMS
IOCDIRS += ZFMAGFLD
IOCDIRS += ZFCNTRL
IOCDIRS += MUONTPAR
IOCDIRS += LKSH372
IOCDIRS += CAENV895
IOCDIRS += LSICORR
IOCDIRS += BGRSCRPT
IOCDIRS += MECFRF
IOCDIRS += FLIPPRPS
IOCDIRS += GALILMUL GALILMUL-OLD GALILMUL-NEW
IOCDIRS += REFL
IOCDIRS += SMTOF70
IOCDIRS += SMRTMON
IOCDIRS += NWPRTXPS
IOCDIRS += TIZR
IOCDIRS += HVCAENA
IOCDIRS += PT2025
IOCDIRS += FMR
IOCDIRS += HIFIMAGS
IOCDIRS += HLX503
IOCDIRS += KHLY6517
IOCDIRS += KHLY2290
IOCDIRS += WEEDER
IOCDIRS += DG645
IOCDIRS += PEARLPC
IOCDIRS += RZBRP100
IOCDIRS += TECHNIX
IOCDIRS += ROTSTIRR
IOCDIRS += WEBCAM
IOCDIRS += HUBER
IOCDIRS += TRANTECH
IOCDIRS += B17TMAG
IOCDIRS += NCINDG
IOCDIRS += TJMPER
IOCDIRS += AEROFLEX
IOCDIRS += TJMPAP
IOCDIRS += INSTRONA
IOCDIRS += TEKOSC
IOCDIRS += KHLY2000
IOCDIRS += CATFLWR
IOCDIRS += PRLTHERM
IOCDIRS += KSE4980
IOCDIRS += PRE4500
IOCDIRS += DHP30330
IOCDIRS += PACE5000
IOCDIRS += MEASM905
IOCDIRS += LM500
IOCDIRS += RKNMNTR
IOCDIRS += ATTOCUBE
IOCDIRS += LITRON
IOCDIRS += LNDYISW
IOCDIRS += ANDOR ANDOR3
IOCDIRS += GENICAM
IOCDIRS += PS300
IOCDIRS += HE3NMR
IOCDIRS += LVREMOTE
IOCDIRS += SR400
IOCDIRS += SR850
IOCDIRS += ENVMON
IOCDIRS += DDSSTRES
IOCDIRS += LDEN3300
IOCDIRS += TLFW102C
IOCDIRS += G3HALLPR
IOCDIRS += NFIPM
IOCDIRS += ZFHIFI
IOCDIRS += OPCUA


## check on missing directories
IOCMAKES = $(wildcard */Makefile)
ALLIOCDIRS = $(IOCMAKES:/Makefile=)
MISSIOCDIRS = $(filter-out $(IOCDIRS),$(ALLIOCDIRS))

DIRS_NOTBUILD += GALIL-OLD GALILMUL-OLD GALIL-NEW GALILMUL-NEW

## modules not to build on linux
ifneq ($(findstring linux,$(EPICS_HOST_ARCH)),)
DIRS_NOTBUILD += MK3CHOPR ECLAB SECI2IBEX
DIRS_NOTBUILD += ASTRIUM CAENV895 FMR
DIRS_NOTBUILD += INSTRONA
DIRS_NOTBUILD += GENICAM
endif

## module decisions based on Visual Studio version
ifneq ($(findstring 10.0,$(VCVERSION)),)
# What not to build with VS2010
DIRS_NOTBUILD += TC HVCAENA GALIL GALILMUL
else
# What not to build if do not have VS2010
#DIRS_NOTBUILD += MK3CHOPR ASTRIUM
endif

## modules not to build on windows 64bit
ifneq ($(findstring windows,$(EPICS_HOST_ARCH)),)
ifeq ($(TWINCAT3DIR),)
DIRS_NOTBUILD += TC
endif
endif

## modules not to build on windows 32bit
ifneq ($(findstring win32,$(EPICS_HOST_ARCH)),)
DIRS_NOTBUILD += MK3CHOPR ASTRIUM
ifeq ($(TWINCAT3DIR),)
DIRS_NOTBUILD += TC
endif
endif

## modules not to build if static
#ifeq ($(BUILDING_SHARED),NO)
#DIRS_NOTBUILD += ISISDAE
#endif

## modules not to build if debug static
ifeq ($(BUILDING_SHARED),NO)
ifneq ($(findstring debug,$(EPICS_HOST_ARCH)),)
#DIRS_NOTBUILD += TC # leftover from old tcIoc
endif
endif

## modules not to build if shared
ifeq ($(BUILDING_SHARED),YES)
DIRS_NOTBUILD += 
endif

## modules not to build if no Windows ATL present (depends on Visual Studio compiler)  
ifneq ($(HAVE_ATL),YES)  
DIRS_NOTBUILD += ISISDAE MERCURY_ITC AG53220A DELFTSHEAR DELFTDCMAG DELFTARDUSTEP LVTEST SCIMAG3D SAMPOS EGXCOLIM COUETTE NIMATRO MUONJAWS
endif

DIRS := $(filter-out $(DIRS_NOTBUILD), $(IOCDIRS))
DIRS := $(sort $(DIRS))

include $(TOP)/configure/RULES_DIRS_INT

install : checkdirs

checkdirs :
ifneq ($(MISSIOCDIRS),)
	$(error Unlisted IOC directories: $(MISSIOCDIRS))
else
	@echo OK - No unlisted IOC directories
endif
