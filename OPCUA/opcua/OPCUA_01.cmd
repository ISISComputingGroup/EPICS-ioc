opcuaSession OPC1 opc.tcp://130.246.88.203:4840
opcuaSubscription SUB1 OPC1 200

opcuaOptions OPC1 sec-mode=None, sec-id="\Instrument\Settings\config\NDW2548\configurations\opcua\cert.txt", debug=10
opcuaClientCertificate "C:\Instrument\Settings\config\NDW2548\configurations\opcua\client_cert.der", "C:\Instrument\Settings\config\NDW2548\configurations\opcua\client_private_key.pem"
dbLoadRecords "$(TOP)/db/OMRON-Sysmac-server-1.db", "P=$(MYPVPREFIX)$(IOCNAME):,R=1,SESS=OPC1,SUBS=SUB1,NS=2"
dbLoadRecords "$(TOP)/db/OMRON-Sysmac-server-2.db", "P=$(MYPVPREFIX)$(IOCNAME):,R=2,SESS=OPC1,SUBS=SUB1,NS=2"
opcuaMapNamespace OPC1 2 "http://isiscomputing-namespace.epics"

