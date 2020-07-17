# In the G21X3Config command, the parameters are:
#
#    int   card number, counting from 0
#    char* ip address, or card location (eg. ASDMC01, 192.6.94.5, /dev/galilpci0, /dev/ttyS0 19200, GALILPCI1)
# ISIS change: COM port specified as e.g. "COM16 115200" on either Linux or windows
#    int   totalaxis used
#    int   model number from this list:
#				  0
#				  100
#				  200
#				  600
#				  700
#				  1000
#				  1200
#				  1410
#				  1411
#				  1412
#				  1415
#				  1417
#				  1500
#				  1600
#				  1700
#				  1800
#				  1802
#				  2000
#				  2100
#    int   communications timeout in ms

#G21X3Config(0,"130.246.51.169",8,2100,2000)
G21X3Config(0,"COM1 115200",8,2100,2000)

# In the G21X3NameConfig command, the parameters are:
#
#    int   cardnumber starting from 0 
#    char  axis A-H,
#    int   motortype, has the following values:
#
#           	0 is a servo motor
#           	1 is a reversed polarity servo motor
#           	2 is a high active pulse stepper
#          	3 is a low active pulse stepper
#           	4 is a reverse high active pulse stepper
#           	5 is a reverse low active pulse stepper
#
#    int   Invert axis coordinates.  Makes -ve coordinate space +ve and vice versa.  Bit 0 = invert motor, Bit 1 = Invert Encoder, Bit 2 = Invert Position Maintenance, Bit 3 = Swap limits
#    int   mainencoder (-1 off, other see manual)),
#    int   auxencoder (-1 off, other see manual), 
#    int   ssiencoderinput (0 off, 1 main enc reg, 2 aux enc reg), 
#    int   limits_as_home (0 off 1 on), 
#    char* slave axis, is of format "B=1.0000,1,uencB=usrVarB,0.00025,0,uencValidVar,C=-.0250,0,uencC=usrVarC,0.00025,0,uencValidVar"
#			      		 "B=1.0000,1, , , , ,C=-.0250,0" - No user encoder for slaves
#			     		 "" no slave
#
#           	That is: axis=gearratio,homeallowed,uenc[Axis]=[expression],ueres,ueoff, uencValidVar, repeat till end of list
#									    (usr encoder resolution)
#									 	  (user encoder offset)
#										         (user encoder reading valid flag 1=valid)
#		
#	    	Where uenc[Axis] is the user encoder input location for [Axis] as specified by
#	    	the [expression].  The uenc[Axis] string actually ends up as Galil code, on the controller.
#	    	If uenc[Axis] is not specified and stepper position maintenance is on, the code generator will
#	   	produce code based on your encoder type (eg. quadrature, SSI, Inverted SSI, etc).  This is an
#	    	advanced setting, and it is not normally specified.  Examples are 3 IVU devices with 2 motors each
#	    	with two SSI encoders, and 1 APS type wiggler with two motors, 2 SSI encoders and two digital interface
#	    	"user" encoders known as gurley virtual absolute encoders.  User encoder relies on user code specified
#           	in G21X3StartCard code file to provide user encoder validation sequence (optional), to set the user encoder
#           	valid flag (uencValidVar, mandatory), and to provide the encoder readback in 
#           	the specified [expression] (mandatory).  The encoder units in [expression] must be raw counts
#           	In user code IF (uencv[Axis] = 1) is used to define the user encoder validation sequence (optional).  
#	    	PV's are:
#           	$(P):$(M)_UEVALIDATE_CMD. Will set uencv[Axis] = 1.  Triggers user provided validation process
#           	$(P):$(M)_UESTATE_CMD.    Requests user encoder state on/off (on may be denied, if not valid)
#           	$(P):$(M)_UESTATE_STATUS. Readback for user encoder state (on/off)
#           	$(P):$(M)_UEVALID_STATUS. User encoder reading valid status
#           	$(P):$(M)_UERAW_MONITOR.  User encoder raw counts
#           	$(P):$(M)_UEDIAL_MONITOR. User encoder dial reading (raw * ueres)
#	    	$(P):$(M)_UEUSER_MONITOR. User encoder user reading (raw * ueres) + ueoff
#
#           	$(P):$(M)_NERAW_MONITOR.  Native encoder raw counts
#           	$(P):$(M)_NEDIAL_MONITOR. Native encoder dial reading (raw * ueres)
#	    	$(P):$(M)_NEUSER_MONITOR. Native encoder user reading (raw * ueres) + ueoff
#
#
#           Always specify last axis last.
#
#           homeallowed is only for system setup purposes, where master and slave are not tightly coupled.  Home allowed is good for homming a
#           slave after the master home is completed.
#
#    int   slave cmd (0 master cmd, 1 master encoder),
#    int   gantrymode (0 off 1 on), 
#		0 Off - applications where master/slave are not tightly/mechanically coupled
#			Limit activation on slave during coupled move will result in slave reverting to independant mode
#			Limit activation on master or slave during independant move results in motor stop only
#		1 On  - applications where master/slave are tightly/mechanically coupled.
#			Limit activation on slave during coupled move will result in master stop
#			Limit activation on master or slave during independant move results in motor stop only
#
#    char* EPS digital home/Motor Interlock Port
#		EPS digital home (0 or "" is off 1-8 nominates port.) 
#		Motor interlock digital port number if -1 to -8 eg. "-1,-2,-4"
#
#    int   EPS digital away/Interlock switch type (Function depends on EPS digital home/Motor Interlock Port value specified.. above)
#               EPS digital away (0 off 1-8 nominates port.  Single int)
#		Interlock switch type 0 normally open, all other values is normally closed interlock switch type
# 
#    char* stepper position maintenance
#		0 off
#		1 on and uses standard encoder settings, and code generator output, or
#		"invalid string" on and uses standard encoder settings, and code generator output
#		"uenc[Axis]=[expression], ueres, ueoff, uencValidVar" on and uses user defined encoder location.  Same format as used for slave definition, see above.

G21X3NameConfig(0,"A",3,0,-1,-1,0,1,"",0,0,"",1,0)
G21X3NameConfig(0,"B",3,0,-1,-1,0,1,"",0,0,"",1,0)
G21X3NameConfig(0,"C",3,0,-1,-1,0,1,"",0,0,"",1,0)
G21X3NameConfig(0,"D",3,0,-1,-1,0,1,"",0,0,"",1,0)
G21X3NameConfig(0,"E",0,0,0,0,0,1,"",0,0,"",1,0)
G21X3NameConfig(0,"F",0,0,0,0,0,1,"",0,0,"",1,0)
G21X3NameConfig(0,"G",0,0,0,0,0,1,"",0,0,"",1,0)
G21X3NameConfig(0,"H",0,0,0,0,0,1,"",0,0,"",1,0)

# In the G21X3StartCard command, the parameters are:
#
#    int   card number starting from 0
#    char* code file to deliver to the card we are starting "" = use generated code
#    int   Burn to EEPROM conditions
#             0 = transfer code if differs from eeprom, dont burn code to eeprom, execute/restart code.
#             1 = transfer code if differs from eeprom, burn code to eeprom, execute/restart code.
#
#    int   display code. Bit 1 displays generated code and or the code file code, Bit 2 displays uploaded code

G21X3StartCard(0,"",1,0)
