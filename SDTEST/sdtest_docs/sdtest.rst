***************
SDTEST IOC
***************

The serial device test module consists of IOCs called SDTEST_01, SDTEST_02 etc. Each of these can control up to 8 separate serial devices.

Configuration of the devices is via EPICS macros, which can be defined in the globals.txt file located in c:/Instrument/settings/config/NDXLARMOR/configurations
This globals.txt file is loaded on IOC startup, so you will need to stop/start the IOC after making a change. 

All macros in globals.txt start with the IOC name followed by two underscores, so SDTEST_01__ for IOC SDTEST_01   Defining a macro  SDTEST_01__NAME3 here will create one that can be referenced as $(NAME3) by IOC SDTEST_01

Each SDTEST IOC supports 8 devices numbered 1 to 8. Settings for each of these have the device number appended e.g. $(PORT3) is COM/serial port for the third device attached etc.

Arbitrary string commands can be sent to the device via EPICS process variables, but it is also possible to define a way to send and receive a particular numeric value through a PV. The format of how to send this value and how often to poll for it need to be specified and this is described later.

By way of example we will consider a power supply. In globals.txt we have:

::

    SDTEST_01__NAME3=Power Supply    # A short name describing the equipment
    SDTEST_01__PORT3=COM15           # MOXA COM port device is attached to
    SDTEST_01__BAUD3=9600            # baud rate of conection
    SDTEST_01__IEOS3=\\r             # end of line terminator for input (note \\ to escape \)
    SDTEST_01__OEOS3=\\r             # end of line terminator for output (note \\ to escape \)
    SDTEST_01__GETOUT3=MC?           # string to send to read the special numeric value      
    SDTEST_01__GETIN3=%f             # expected format of reply to sending string specified in GETOUT
    SDTEST_01__SCAN3=.5 second       # scan (polling) rate for reading special numeric value. 
    SDTEST_01__SETOUTA3=PC           # first part of string to send for setting special numeric value
    SDTEST_01__SETOUTB3=0x20         # second part of string to send for setting special numeric value
    SDTEST_01__SETOUTC3=%f           # third part of string to send for setting special numeric value
    SDTEST_01__SETIN3=OK             # expected reply from SETOUT* Use e.g. %*40c to ignore reply

As these all start SDTEST_01__ and end in 3 they refer to the third device attahced to IOC SDTEST_01
You do not need to specify all values, here are defaults

======= =======   ================================================================================================================
Macro   Default   Notes
======= =======   ================================================================================================================
BAUD    9600      Serial connection baud rate
BITS    8         Number of data bits
PARITY  none      Can be none, odd or even
STOP    1         Number of stop bits
CLOCAL  Y         if N, output flow control using DSR signal
CRTSCTS N         if Y, use hardware flow control (RTS/CTS)
IXON    N         if Y, use software flow control for output
IXOFF   N         if Y, use software flow control for input
OEOS    \\r\\n    Output end of string/line character(s)
IEOS    \\r\\n    Input end of string/line characters(s)
SCAN    Passive   Any valid EPICS scan value (Passive, .1 second, .2 second, 
                  .. .5 second, 1 second, 2 second, 5 second or 10 second)
======= =======   ================================================================================================================

Process variables defined are of the form {instrument prefix}{ioc name}{device index}{variable} e.g. for the first device (P1) on IOC SDTEST_01

==================================== ======= ===================================================================================
Process variable                     Access  Description
==================================== ======= ===================================================================================
IN:LARMOR:SDTEST_01:P1:NAME          (read)  short name of device 
IN:LARMOR:SDTEST_01:P1:DEVICE        (read)  COM port of device
IN:LARMOR:SDTEST_01:P1:INIT          (write) initialise device
IN:LARMOR:SDTEST_01:P1:COMM          (write) send arbitrary string to device
IN:LARMOR:SDTEST_01:P1:REPLY         (read)  reply from device after sending COMM string above
IN:LARMOR:SDTEST_01:P1:REPLY:ASYNC   (read)  continuously monitors serial port for 
                                             .. asynchronous output (40 char epics string)
IN:LARMOR:SDTEST_01:P1:REPLYWF:ASYNC (read)  continuously monitors serial port for asynchronous 
                                             .. output (epics 1024 char waveform)
IN:LARMOR:SDTEST_01:P1:SETVAL        (write) write a numeric value to device using previously 
                                             .. specified command format
IN:LARMOR:SDTEST_01:P1:GETVAL        (read)  numeric value read from device (ususally because 
                                             .. of a periodic SCAN)
IN:LARMOR:SDTEST_01:P1:ASYNREC       (write) Access to an EPICS ASYN record 
                                             .. http://www.aps.anl.gov/epics/modules/soft/asyn/R4-26/asynRecord.html 
==================================== ======= ===================================================================================

When polling the GETVAL process variable, the the IOC will send $(GETOUT) and expect to receive $(GETIN)  Within $(GETIN) can be printf style format characters to match
the value being read. For valid format converters see http://epics.web.psi.ch/software/streamdevice/doc/formats.html

When writing to the SETVAL process variable, the IOC will construct a string from concaternating $(SETOUTA), $(SETOUTB) and $(SETOUTC). The writing format character (e.g. %f)
must be in SETOUTC, normally only SETOUTA and SETOUTC are specified, sometimes just SETOUTC. SETOUTB is for sending a special character between these two values, such as a space.
SETOUTA and SETOUTC are quoted strings as per http://epics.web.psi.ch/software/streamdevice/doc/protocol.html whereas SETOUTB can be a byte number such as 0x20 for a space character.  Only use SETOUTB is you have trouble with using SETOUTA and SETOUTC - in particular needing to send a space character between and string
and a format converter that seems to get stripped otherwise.

For INIT, macros INITOUT and INITIN 
 
The ASYN record PV can be useful for diagnostics

-------------------
SDTEST Synoptic OPI
-------------------

An OPI file SDTEST.opt exists that opens a display for managing the serial device, which
includes the option to open an ayn record OPI - see screenshots at bottom 
of http://www.aps.anl.gov/epics/modules/soft/asyn/R4-26/asynRecord.html

------------------
More complex cases
------------------

===== ====================  ================================================================================================================
Macro Default               Notes
===== ====================  ================================================================================================================
PROTO SDTEST-default.proto  Stream device protocol file to use

You can specify your own protocol file to use. Details of protocol file format are at
http://epics.web.psi.ch/software/streamdevice/doc/  

because you will load the same DB file, you will need to provide the same functions as SDTEST-default.proto  i.e. getValue() and setValue()
Place files in $(ICPCONFIGROOT)/SDTEST on machine


