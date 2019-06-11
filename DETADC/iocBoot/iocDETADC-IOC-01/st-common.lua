pvprefix = os.getenv("MYPVPREFIX")
iocname = os.getenv("IOCNAME")
for index=1,9,1
do
    ip = os.getenv(string.format("ADDR_%d", index))
    port = string.format("PORT_%d", index)
    if (ip and string.len(ip)) then
        print(string.format("Configuring for %s", ip))
        iocsh.daedataConfigure(port, ip, 1)
        daedatadb = string.format("%s/db/daedata.db",os.getenv("ISISDAEDATA"))
        iocsh.dbLoadRecords(daedatadb, string.format("P=%s%s:P%d:,PORT=%s", pvprefix, iocname, index, port))
    end
end
