calc("AX", "$(SLOT)+1", 0, 1)
calc("MTR", "$(SLOT)+1", 2, 2)

dbLoadRecords("$(MOTOR)/db/motor.db","P=$(MYPVPREFIX),M=MOT:MTR$(MTRCTRL)$(MTR),DTYP=$(MDEV),MOTORSIM=$(MSIM=),C=0,S=$(SLOT),DESC=ESP300,EGU=mm,DIR=Pos,VELO=1,VBAS=.1,ACCL=.2,BDST=0,BVEL=1,BACC=.2,MRES=5e-5,PREC=5,DHLM=100,DLLM=-100,INIT="
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=MOT:MTR$(MTRCTRL)$(MTR),IOCNAME=$(IOCNAME)")
dbLoadRecords("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS$(AX),mAXIS=MOT:MTR$(MTRCTRL)$(MTR)") 

