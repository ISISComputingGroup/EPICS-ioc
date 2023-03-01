TOP=../..
# This file should do very little - it's purpose is to set the APPNAME and then load build.mak

# this definition is used in build.mak
APPNAME=HVCAENA-IOC-01

# copy in the caenhvwrapper we used - this is so we do not pick up a system installed one
# need to do here to avoid parallel copy failure
BIN_INSTALLS_WIN32 += $(HVCAEN)/bin/$(EPICS_HOST_ARCH)/CAENHVWrapper.dll

# If we are ###-IOC-01 leave this as is, if we are ###-IOC-02 or higher change to ###-IOC-01 and delete build.mak from this directory
# there should only be a single build.mak for all IOCs of a given family and it is located in the ###-IOC-01 directory
include $(TOP)/HVCAENA-IOC-01App/src/build.mak
