stringiftest("ALIASED", "$(CHAN$(CHAN)NAME=)", 3, "")

dbLoadRecords("${TOP}/db/channel_aliases.db","P=$(MYPVPREFIX)$(IOCNAME), NAME=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E1210_ASYNPORT), CHANNAME=$(CHAN$(CHAN)NAME=), IFALIASED=$(IFALIASED), IFNOTALIASED=$(IFNOTALIASED), CHAN=$(CHAN)")
