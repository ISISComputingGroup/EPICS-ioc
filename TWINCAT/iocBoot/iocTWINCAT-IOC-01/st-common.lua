motor_port = "L0"
num_axes = 8
pv_prefix = os.getenv("MYPVPREFIX")
tpy_file = os.getenv("TPY_FILE")

iocsh.tcSetAlias("PLC:TEST:")
iocsh.tcSetScanRate(10, 5)
iocsh.tcLoadRecords (tpy_file, "-eo -devtc")

iocsh.devMotorCreateController(motor_port, "Controller", num_axes)

for axis_num=1,num_axes,1
do
    motor_pv = string.format("MTR%02i%02i", os.getenv("MTRCTRL"), axis_num)
    single_axis_db = "db/single_axis.db"
    db_args = string.format("MYPVPREFIX=%s,MOTOR_PV=%s,MOTOR_PORT=%s,ADDR=%s", pv_prefix, motor_pv, motor_port, axis_num-1)
	iocsh.devMotorCreateAxis(motor_port, axis_num-1)
	iocsh.dbLoadRecords(single_axis_db, db_args)
end
