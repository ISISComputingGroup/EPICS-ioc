
## set MN before calling
## if MN=1 the defines asyn port SD1 and uses macros such as VELO1, ACCL1 to configure 

# this defines macros we can use for conditional loading later
stringiftest("AXIS$(MN)", "$(AXIS$(MN)=)",5,"yes")
$(IFAXIS$(MN)) < ${TOP}/iocBoot/iocNFIPM-IOC-01/st-motor.cmd
