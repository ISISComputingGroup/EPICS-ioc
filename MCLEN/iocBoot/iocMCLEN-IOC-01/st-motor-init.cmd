## Initialises values at the motor level. Experience suggests the IOC doesn't do this automatically

asynOctetConnect("MKINIT","$(ASERIAL)")

## Some things that are helpful in development mode. Resetting, initialising. Probably don't want to do it in production
#asynOctetWrite("MKINIT","$(MN)RS")
#asynOctetWrite("MKINIT","$(MN)IN")

## Check if open loop mode has been requested
stringiftest("CMOPEN", "$(CMOD$(MN)=)",5,"OPEN")

## Initialise control mode. Defaults to CM14, closed
$(IFCMOPEN) asynOctetWrite("MKINIT","$(MN)CM11")
$(IFNOTCMOPEN) asynOctetWrite("MKINIT","$(MN)CM14")

## Initialise the encoder ratio using the exact string of ERES$
asynOctetWrite("MKINIT","$(MN)ER$(ERES$(MN)=400/4096)")

## end of move check window
asynOctetWrite("MKINIT","$(MN)WI5")

## Not Complete/Time-Out time
asynOctetWrite("MKINIT","$(MN)TO8000")

## tracking window
asynOctetWrite("MKINIT","$(MN)TR4000")

## SL1 enables soft limits in controller, SL0 disables
## we disable for now until we are sure they work
## see comment in driver
asynOctetWrite("MKINIT","$(MN)SL0")

## backoff steps as 0
asynOctetWrite("MKINIT","$(MN)BO0")

## creep steps at end of move
#asynOctetWrite("MKINIT","$(MN)CR10")
asynOctetWrite("MKINIT","$(MN)CR5")

## creep speed
#asynOctetWrite("MKINIT","$(MN)CS250")

## settle time
asynOctetWrite("MKINIT","$(MN)SE1000")

## set abort mode, controller default is 00000000
## however passing 00111000 for example would make stall error, tracking error and timeout error not abort motion 
asynOctetWrite("MKINIT","$(MN)AM00000000")

## set datum mode, controller default is 00000000
## this also controls expected encoder index polarity, automatic direction search etc. on datum
## not set at moment
#asynOctetWrite("MKINIT","$(MN)DM00000000")

## define home position as 0, this will be applied if DM set accordingly
#asynOctetWrite("MKINIT","$(MN)SH0")
