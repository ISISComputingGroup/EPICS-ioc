## Initialises values at the motor level. Experience suggests the IOC doesn't do this automatically

asynOctetConnect("MKINIT","$(ASERIAL)")

## send escape to clear buffer and stop any motion etc.
#asynOctetWriteRead("MKINIT","\x1B")
#asynOctetWriteRead("MKINIT","$(MN)RS")

## Some things that are helpful in development mode. Resetting, initialising. Probably don't want to do it in production
#asynOctetWriteRead("MKINIT","$(MN)IN")

## Check if open loop mode has been requested
stringiftest("CMOPEN", "$(CMOD$(MN)=)",5,"OPEN")

## Initialise control mode. Defaults to CM14, closed
$(IFCMOPEN) asynOctetWriteRead("MKINIT","$(MN)CM11")
$(IFNOTCMOPEN) asynOctetWriteRead("MKINIT","$(MN)CM14")

## Initialise the encoder ratio using the exact string of ERES$
asynOctetWriteRead("MKINIT","$(MN)ER$(ERES$(MN)=400/4096)")

## end of move check window, allowed difference at end of move
asynOctetWriteRead("MKINIT","$(MN)WI$(WINI)")

## Not Complete/Time-Out time
asynOctetWriteRead("MKINIT","$(MN)TO8000")

## tracking window, allowed difference between motor and encoder when moving
## get tracking abort if exceeded
asynOctetWriteRead("MKINIT","$(MN)TR4000")

## SL1 enables soft limits in controller, SL0 disables
## we disable for now until we are sure they work
## see comment in driver
asynOctetWriteRead("MKINIT","$(MN)SL0")

## backoff steps as 0
asynOctetWriteRead("MKINIT","$(MN)BO$(BOSTI)")

## creep steps at end of move, 10 is default for stepper
asynOctetWriteRead("MKINIT","$(MN)CR$(CRSTI)")

## creep speed, 800 is default
asynOctetWriteRead("MKINIT","$(MN)SC$(CRSPI)")

## settle time, how long must remain in Window at end of move, 100 is default
asynOctetWriteRead("MKINIT","$(MN)SE$(SETLI)")

## set abort mode, controller default is 00000000
## however passing 00111000 for example would make stall error, tracking error and timeout error not abort motion 
asynOctetWriteRead("MKINIT","$(MN)AM00000000")

## set datum mode, controller default is 00000000
## this also controls expected encoder index polarity, automatic direction search etc. on datum
## so not set at moment in case mess up encoder? It is partly adjusted in the main
## driver depending on homing mode
#asynOctetWriteRead("MKINIT","$(MN)DM00000000")

## note: SH command generally not set here, if we chose appropriate hardware home
## main driver will do a SH0 before homing to datum if in appropriate mode
#asynOctetWriteRead("MKINIT","$(MN)SH0")

epicsThreadSleep(1.0)
