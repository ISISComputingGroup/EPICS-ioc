pv_prefix = os.getenv("MYPVPREFIX")
p = string.format("%s%s", pv_prefix, os.getenv("IOCNAME"))
num_axes = os.getenv("NUM_AXES")
controller_port = os.getenv("DEVICE")
motor_port = os.getenv("MOTOR_PORT")

iocsh.dbLoadRecords("db/common.db", string.format("P=%s,PORT=%s", p, controller_port))

for axis_num=1,num_axes,1
do
    motor_pv = string.format("MTR%02i%02i", os.getenv("MTRCTRL"), axis_num)
    single_axis_db = "db/single_axis.db"
    db_args = string.format("P=%s,MYPVPREFIX=%s,MOTOR_PV=%s,CONTROLLER_PORT=%s,MOTOR_PORT=%s,ADDR=%s", p, pv_prefix, motor_pv, controller_port, motor_port, axis_num-1)
    iocsh.dbLoadRecords(single_axis_db, db_args)
end
