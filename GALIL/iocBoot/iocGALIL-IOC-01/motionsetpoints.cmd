# $(ICPCONFIGDIR) or $(ICPCONFIGROOT) ?
$(IFDMC06) epicsEnvSet "LOOKUPFILE1" "$(ICPCONFIGROOT)/motionSetPoints/monitor3.txt"
$(IFDMC06) epicsEnvSet "LOOKUPFILE2" "$(ICPCONFIGROOT)/motionSetPoints/monitor4.txt"
$(IFDMC05) epicsEnvSet "LOOKUPFILE3" "$(ICPCONFIGROOT)/motionSetPoints/sample_x.txt"
$(IFDMC05) epicsEnvSet "LOOKUPFILE4" "$(ICPCONFIGROOT)/motionSetPoints/sample_y.txt"

$(IFDMC06) motionSetPointsConfigure("LOOKUPFILE1","LOOKUPFILE1")
$(IFDMC06) motionSetPointsConfigure("LOOKUPFILE2","LOOKUPFILE2")
$(IFDMC05) motionSetPointsConfigure("LOOKUPFILE3","LOOKUPFILE3")
$(IFDMC05) motionSetPointsConfigure("LOOKUPFILE4","LOOKUPFILE4")

$(IFDMC06) dbLoadRecords("$(MOTIONSETPOINTS)/db/motionSetPoints.db","P=$(MYPVPREFIX)LKUP:MON3:,TARGET_PV1=$(MYPVPREFIX)MOT:MTR0601,TARGET_RBV1=$(MYPVPREFIX)MOT:MTR0601.RBV,TARGET_DONE=$(MYPVPREFIX)MOT:MTR0601.DMOV,TOL=1,LOOKUP=LOOKUPFILE1")
$(IFDMC06) dbLoadRecords("$(MOTIONSETPOINTS)/db/motionSetPoints.db","P=$(MYPVPREFIX)LKUP:MON4:,TARGET_PV1=$(MYPVPREFIX)MOT:MTR0602,TARGET_RBV1=$(MYPVPREFIX)MOT:MTR0602.RBV,TARGET_DONE=$(MYPVPREFIX)MOT:MTR0602.DMOV,TOL=1,LOOKUP=LOOKUPFILE2")
$(IFDMC05) dbLoadRecords("$(MOTIONSETPOINTS)/db/motionSetPoints.db","P=$(MYPVPREFIX)LKUP:SAMPX:,TARGET_PV1=$(MYPVPREFIX)MOT:MTR0502,TARGET_RBV1=$(MYPVPREFIX)MOT:MTR0502.RBV,TARGET_DONE=$(MYPVPREFIX)MOT:MTR0502.DMOV,FILTER_SRC=$(MYPVPREFIX)LKUP:SAMPY:FILTER:OUT,TOL=1,LOOKUP=LOOKUPFILE3")
$(IFDMC05) dbLoadRecords("$(MOTIONSETPOINTS)/db/motionSetPoints.db","P=$(MYPVPREFIX)LKUP:SAMPY:,TARGET_PV1=$(MYPVPREFIX)MOT:MTR0507,TARGET_RBV1=$(MYPVPREFIX)MOT:MTR0507.RBV,TARGET_DONE=$(MYPVPREFIX)MOT:MTR0507.DMOV,TOL=1,LOOKUP=LOOKUPFILE4")
