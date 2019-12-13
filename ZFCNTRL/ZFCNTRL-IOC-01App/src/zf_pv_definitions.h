/* Field readings from magnetometer */
PV(double, magnetometer_x, "{P}FIELD:X:_RAW", Monitor);
PV(double, magnetometer_y, "{P}FIELD:Y:_RAW", Monitor);
PV(double, magnetometer_z, "{P}FIELD:Z:_RAW", Monitor);

/* Severities from magnetometer */
PV(int, magnetometer_x_sevr, "{P}FIELD:X:_RAW.SEVR", Monitor);
PV(int, magnetometer_y_sevr, "{P}FIELD:Y:_RAW.SEVR", Monitor);
PV(int, magnetometer_z_sevr, "{P}FIELD:Z:_RAW.SEVR", Monitor);

/* Magnetometer overload */
PV(int, magnetometer_overloaded, "{P}MAGNETOMETER:OVERLOAD", Monitor);

/* Field setpoints */
PV(double, setpoint_x, "{P}FIELD:X:SP", Monitor);
PV(double, setpoint_y, "{P}FIELD:Y:SP", Monitor);
PV(double, setpoint_z, "{P}FIELD:Z:SP", Monitor);

/* Power supply currents */
PV(double, output_psu_x, "{P}OUTPUT:X:CURR", Monitor);
PV(double, output_psu_y, "{P}OUTPUT:Y:CURR", Monitor);
PV(double, output_psu_z, "{P}OUTPUT:Z:CURR", Monitor);
PV(int, output_psu_x_sevr, "{P}OUTPUT:X:CURR.SEVR", Monitor);
PV(int, output_psu_y_sevr, "{P}OUTPUT:Y:CURR.SEVR", Monitor);
PV(int, output_psu_z_sevr, "{P}OUTPUT:Z:CURR.SEVR", Monitor);

/* Power supply setpoints */
PV(double, output_psu_x_sp, "{P}OUTPUT:X:CURR:SP", NoMon);
PV(double, output_psu_y_sp, "{P}OUTPUT:Y:CURR:SP", NoMon);
PV(double, output_psu_z_sp, "{P}OUTPUT:Z:CURR:SP", NoMon);
PV(int, output_psu_x_sp_sevr, "{P}OUTPUT:X:CURR:SP.SEVR", Monitor);
PV(int, output_psu_y_sp_sevr, "{P}OUTPUT:Y:CURR:SP.SEVR", Monitor);
PV(int, output_psu_z_sp_sevr, "{P}OUTPUT:Z:CURR:SP.SEVR", Monitor);

/* Power supply setpoint limits */
PV(double, output_psu_x_sp_drvh, "{P}OUTPUT:X:CURR:SP.DRVH", Monitor);
PV(double, output_psu_y_sp_drvh, "{P}OUTPUT:Y:CURR:SP.DRVH", Monitor);
PV(double, output_psu_z_sp_drvh, "{P}OUTPUT:Z:CURR:SP.DRVH", Monitor);
PV(double, output_psu_x_sp_drvl, "{P}OUTPUT:X:CURR:SP.DRVL", Monitor);
PV(double, output_psu_y_sp_drvl, "{P}OUTPUT:Y:CURR:SP.DRVL", Monitor);
PV(double, output_psu_z_sp_drvl, "{P}OUTPUT:Z:CURR:SP.DRVL", Monitor);

/* Power supply setpoint readbacks */
PV(double, output_psu_x_sp_rbv, "{P}OUTPUT:X:CURR:SP:RBV", Monitor);
PV(double, output_psu_y_sp_rbv, "{P}OUTPUT:Y:CURR:SP:RBV", Monitor);
PV(double, output_psu_z_sp_rbv, "{P}OUTPUT:Z:CURR:SP:RBV", Monitor);
PV(int, output_psu_x_sp_rbv_sevr, "{P}OUTPUT:X:CURR:SP:RBV.SEVR", Monitor);
PV(int, output_psu_y_sp_rbv_sevr, "{P}OUTPUT:Y:CURR:SP:RBV.SEVR", Monitor);
PV(int, output_psu_z_sp_rbv_sevr, "{P}OUTPUT:Z:CURR:SP:RBV.SEVR", Monitor);

/* Power supply outputs */
PV(int, output_psu_x_on, "{P}OUTPUT:X:STATUS", Monitor);
PV(int, output_psu_y_on, "{P}OUTPUT:Y:STATUS", Monitor);
PV(int, output_psu_z_on, "{P}OUTPUT:Z:STATUS", Monitor);
PV(int, output_psu_x_on_sevr, "{P}OUTPUT:X:STATUS.SEVR", Monitor);
PV(int, output_psu_y_on_sevr, "{P}OUTPUT:Y:STATUS.SEVR", Monitor);
PV(int, output_psu_z_on_sevr, "{P}OUTPUT:Z:STATUS.SEVR", Monitor);
PV(int, output_psu_x_on_sp, "{P}OUTPUT:X:STATUS:SP", NoMon);
PV(int, output_psu_y_on_sp, "{P}OUTPUT:Y:STATUS:SP", NoMon);
PV(int, output_psu_z_on_sp, "{P}OUTPUT:Z:STATUS:SP", NoMon);

/* Power supply output modes */
PV(int, output_psu_x_mode, "{P}OUTPUT:X:MODE", Monitor);
PV(int, output_psu_y_mode, "{P}OUTPUT:Y:MODE", Monitor);
PV(int, output_psu_z_mode, "{P}OUTPUT:Z:MODE", Monitor);
PV(int, output_psu_x_mode_sevr, "{P}OUTPUT:X:MODE.SEVR", Monitor);
PV(int, output_psu_y_mode_sevr, "{P}OUTPUT:Y:MODE.SEVR", Monitor);
PV(int, output_psu_z_mode_sevr, "{P}OUTPUT:Z:MODE.SEVR", Monitor);
PV(int, output_psu_x_mode_sp, "{P}OUTPUT:X:MODE:SP", NoMon);
PV(int, output_psu_y_mode_sp, "{P}OUTPUT:Y:MODE:SP", NoMon);
PV(int, output_psu_z_mode_sp, "{P}OUTPUT:Z:MODE:SP", NoMon);

/* Power supply write tolerance */
PV(double, output_psu_tolerance, "{P}OUTPUT:PSU_WRITE_TOLERANCE", Monitor);

/* Proportional feedback factors and fiddle factors */
PV(double, amps_per_mg_x, "{P}P:X", Monitor);
PV(double, amps_per_mg_y, "{P}P:Y", Monitor);
PV(double, amps_per_mg_z, "{P}P:Z", Monitor);
PV(double, feedback, "{P}P:FEEDBACK", Monitor);

/* Tolerance of (actual-setpoint) for field to be considered stable */
PV(double, tolerance, "{P}TOLERANCE", Monitor);

/* Statuses for feedback to OPI etc */
PV(string, statemachine_state, "{P}STATEMACHINE:STATE", NoMon);
PV(int, statemachine_activity, "{P}STATEMACHINE:ACTIVITY", Monitor);
PV(double, statemachine_measured_loop_time, "{P}STATEMACHINE:LOOP_TIME", NoMon); /* msec */
PV(double, loop_delay, "{P}STATEMACHINE:LOOP_DELAY", Monitor); /* msec */
PV(double, read_timeout, "{P}STATEMACHINE:READ_TIMEOUT", Monitor); /* sec */
PV(string, status, "{P}STATUS", NoMon);
PV(int, stable, "{P}STABLE", Monitor);

/* Whether new readings are available from the magnetometer */
PV(int, new_readings_available, "{P}_READINGS_READY", Monitor);
/* Trigger the magnetometer to take new readings */
PV(int, trigger_read, "{P}TRIGGER_MAGNETOMETER_READ", NoMon);

/* Whether the controller is in auto-feedback mode */
PV(int, auto_feedback_enabled, "{P}AUTOFEEDBACK", Monitor);

/* Statemachine debugging - e.g. logging of every state entry. Very verbose. */
PV(int, debug, "{P}DEBUG", Monitor);
