TOP = ..
include $(TOP)/configure/CONFIG

.PHONY: updatedlls

include $(TOP)/configure/RULES_DIRS

install : updatedlls

updatedlls :
	update_dlls.bat