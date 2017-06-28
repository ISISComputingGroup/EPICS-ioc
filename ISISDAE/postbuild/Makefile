TOP = ..
include $(TOP)/configure/CONFIG

.PHONY: updatedlls

include $(TOP)/configure/RULES_DIRS

install : updatedlls

updatedlls :
ifneq ($(findstring windows,$(EPICS_HOST_ARCH)),)
	update_dlls.bat
endif
