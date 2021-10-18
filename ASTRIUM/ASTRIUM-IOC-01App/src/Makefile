TOP=../..
# This file should do very little - it's purpose is to set the APPNAME and then load build.mak
#LIBRARY_IOC=AstriumLib

#AstriumLib_SRCS += astriumDriver.cpp astriumInterface.cpp

#AstriumLib_LIBS += asyn AstriumBridgeLib $(EPICS_BASE_IOC_LIBS)

# this definition is used in build.mak
APPNAME=ASTRIUM-IOC-01

# If we are ###-IOC-01 leave this as is, if we are ###-IOC-02 or higher change to ###-IOC-01 and delete build.mak from this directory
# there should only be a single build.mak for all IOCs of a given family and it is located in the ###-IOC-01 directory
include $(TOP)/ASTRIUM-IOC-01App/src/build.mak
