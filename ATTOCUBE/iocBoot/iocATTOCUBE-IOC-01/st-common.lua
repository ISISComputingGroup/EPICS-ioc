device = "L0"
motor_port = "MTR"
num_axes = 3
pv_prefix = os.getenv("MYPVPREFIX")
p = string.format("%s%s", pv_prefix, os.getenv("IOCNAME"))
recsim = os.getenv("RECSIM") == "1"
devsim = os.getenv("DEVSIM") == "1"
emulator_port = os.getenv("EMULATOR_PORT")
if(emulator_port==nil) then
    emulator_port=57677
end

if(recsim) then
    iocsh.drvAsynSerialPortConfigure(device, "NUL", 0, 1, 0, 0)
else
    if(devsim) then
        connection_string = string.format("localhost:%i", emulator_port)
    else
        connection_string = string.format("%s:2101", os.getenv("IP_ADDR"))
    end
    print("Connecting on " .. connection_string)
    iocsh.drvAsynIPPortConfigure(device, connection_string)
    iocsh.anc350AsynMotorCreate(device, "0", "0", num_axes)
    iocsh.drvAsynMotorConfigure(motor_port, "anc350AsynMotor", "0", num_axes)
end

iocsh.dbLoadRecords("db/common.db", string.format("P=%s,PORT=%s", p, device))

for axis_num=1,num_axes,1
do
    motor_pv = string.format("MTR%02i%02i", os.getenv("MTRCTRL"), axis_num)
    single_axis_db = "db/single_axis.db"
    db_args = string.format("P=%s,MYPVPREFIX=%s,MOTOR_PV=%s,CONTROLLER_PORT=%s,MOTOR_PORT=%s,ADDR=%s", p, pv_prefix, motor_pv, device, motor_port, axis_num-1)
    iocsh.dbLoadRecords(single_axis_db, db_args)
end
