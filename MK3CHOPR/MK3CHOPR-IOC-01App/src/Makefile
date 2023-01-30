TOP=../..
# This file should do very little - it's purpose is to set the APPNAME and then load build.mak

# this definition is used in build.mak
APPNAME=MK3CHOPR-IOC-01

# need to do here and not build.mak to avoid parallel copy comflict 
BIN_INSTALLS_WIN32 += $(wildcard $(SUPPORT)/mk3Chopper/master/bin/$(EPICS_HOST_ARCH)/*.dll)

# If we are ###-IOC-01 leave this as is, if we are ###-IOC-02 or higher change to ###-IOC-01 and delete build.mak from this directory
# there should only be a single build.mak for all IOCs of a given family and it is located in the ###-IOC-01 directory
include $(TOP)/MK3CHOPR-IOC-01App/src/build.mak
