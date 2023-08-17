stringiftest("ALIASED", "$($(CHANPREFIX=)CHAN$(CHAN)NAME=)", 3, "")

$(IFALIASED) dbLoadRecords("${TOP}/db/moxa12XX_aliases.db","P=$(MYPVPREFIX)$(IOCNAME), NAME=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT), CHANNAME=$($(CHANPREFIX=)CHAN$(CHAN)NAME=), FNCTN=$(FNCTN), IFALIASED=$(IFALIASED), IFNOTALIASED=$(IFNOTALIASED), CHAN=$(CHAN)")

$(IFMOXA1240) $(IFALIASED) dbLoadRecords("${TOP}/db/moxa_e1240_misc.db","NAME=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT), CHAN=$(CHAN), HIGHLIMIT=$(CHAN$(CHAN)HILIMIT=10.0), LOWLIMIT=$(CHAN$(CHAN)LOWLIMIT=0.0), UNITS=$(CHAN$(CHAN)UNITS=V), SCLEFACTR=$(CHAN$(CHAN)SCLEFACTR=1.0)")

$(IFMOXA1242) $(IFALIASED) dbLoadRecords("${TOP}/db/moxa_e1242_misc.db","NAME=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT), CHAN=$(CHAN), HIGHLIMIT=$(CHAN$(CHAN)HILIMIT=10.0), LOWLIMIT=$(CHAN$(CHAN)LOWLIMIT=0.0), UNITS=$(CHAN$(CHAN)UNITS=V), SCLEFACTR=$(CHAN$(CHAN)SCLEFACTR=1.0)")

$(IFMOXA1262) $(IFALIASED) dbLoadRecords("${TOP}/db/moxa_e1262_misc.db","NAME=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT), CHAN=$(CHAN), HIGHLIMIT=$(CHAN$(CHAN)HILIMIT=1100.0), LOWLIMIT=$(CHAN$(CHAN)LOWLIMIT=-180.0)")
