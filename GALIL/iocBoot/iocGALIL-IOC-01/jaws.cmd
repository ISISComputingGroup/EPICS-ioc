# Define a set of jaws from first 4 motors on first controller (if present)
$(IFDMC01) dbLoadRecords("$(JAWS)/db/jaws.db","P=$(MYPVPREFIX)MOT:,JAWS=JAWS1:,mXN=MTR0101,mXS=MTR0102,mXW=MTR0103,mXE=MTR0104")
$(IFDMC01) dbLoadRecords("$(JAWS)/db/jaws.db","P=$(MYPVPREFIX)MOT:,JAWS=JAWS2:,mXN=MTR0105,mXS=MTR0106,mXW=MTR0107,mXE=MTR0108")

# Define a set of jaws from first 4 motors on second controller (if present)
$(IFDMC02) dbLoadRecords("$(JAWS)/db/jaws.db","P=$(MYPVPREFIX)MOT:,JAWS=JAWS3:,mXN=MTR0201,mXS=MTR0202,mXW=MTR0203,mXE=MTR0204")
$(IFDMC02) dbLoadRecords("$(JAWS)/db/jaws.db","P=$(MYPVPREFIX)MOT:,JAWS=JAWS4:,mXN=MTR0205,mXS=MTR0206,mXW=MTR0207,mXE=MTR0208")
