TOP = ../..
include $(TOP)/configure/CONFIG
ARCH = $(EPICS_HOST_ARCH)
TARGETS = envPaths dllPath.bat cdCommands runIOC.bat relPaths.sh runIOC.sh dllCopy.bat
include $(TOP)/configure/RULES.ioc
install :
	dllCopy.bat
