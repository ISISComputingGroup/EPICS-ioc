TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

#----------------------------------------------------
#  Optimization of db files using dbst (DEFAULT: NO)
#DB_OPT = YES

#----------------------------------------------------
# Create and install (or just install) into <top>/db
# databases, templates, substitutions like this
#DB += xxx.db
DB += DFKPS_RIKEN.db
DB += DFKPS_RIKEN_STATUS.db
DB += DFKPS_RIKEN_STATUS_ERRORS.db
DB += riken_changeover.db
DB += riken_port_changeover_psus.db
DB += riken_rb2_mode_changeover_psus.db
DB += riken_psu_banner.db
DB += riken_port_monitor.db
DB += riken_daqmx.db

#----------------------------------------------------
# If <anyname>.db template is not named <anyname>*.template add
# <anyname>_template = <templatename>

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

