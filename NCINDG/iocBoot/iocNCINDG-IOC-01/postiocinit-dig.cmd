dbpf "$(MYPVPREFIX)$(IOCNAME):D$(DIG):AD1:FILE:XMLFileName", "${TOP}/iocBoot/iocNCINDG-IOC-01/hdf5_layout.xml"
dbpf "$(MYPVPREFIX)$(IOCNAME):D$(DIG):AD2:FILE:XMLFileName", "${TOP}/iocBoot/iocNCINDG-IOC-01/hdf5_layout.xml"
dbpf "$(MYPVPREFIX)$(IOCNAME):D$(DIG):AD3:FILE:XMLFileName", "${TOP}/iocBoot/iocNCINDG-IOC-01/hdf5_layout.xml"
dbpf "$(MYPVPREFIX)$(IOCNAME):D$(DIG):AD1:NDAttributesFile", "${TOP}/iocBoot/iocNCINDG-IOC-01/hdf5_attributes.xml"
dbpf "$(MYPVPREFIX)$(IOCNAME):D$(DIG):AD2:NDAttributesFile", "${TOP}/iocBoot/iocNCINDG-IOC-01/hdf5_attributes.xml"
dbpf "$(MYPVPREFIX)$(IOCNAME):D$(DIG):AD3:NDAttributesFile", "${TOP}/iocBoot/iocNCINDG-IOC-01/hdf5_attributes.xml"

stringiftest("DIG0", "$(DIG=)", 5, "0")

$(IFDIG0) dbpf "$(MYPVPREFIX)$(IOCNAME):D$(DIG):AD4:FILE:XMLFileName", "${TOP}/iocBoot/iocNCINDG-IOC-01/hdf5_layout.xml"
$(IFDIG0) dbpf "$(MYPVPREFIX)$(IOCNAME):D$(DIG):AD5:FILE:XMLFileName", "${TOP}/iocBoot/iocNCINDG-IOC-01/hdf5_layout.xml"
$(IFDIG0) dbpf "$(MYPVPREFIX)$(IOCNAME):D$(DIG):AD6:FILE:XMLFileName", "${TOP}/iocBoot/iocNCINDG-IOC-01/hdf5_layout.xml"
$(IFDIG0) dbpf "$(MYPVPREFIX)$(IOCNAME):D$(DIG):AD4:NDAttributesFile", "${TOP}/iocBoot/iocNCINDG-IOC-01/hdf5_attributes.xml"
$(IFDIG0) dbpf "$(MYPVPREFIX)$(IOCNAME):D$(DIG):AD5:NDAttributesFile", "${TOP}/iocBoot/iocNCINDG-IOC-01/hdf5_attributes.xml"
$(IFDIG0) dbpf "$(MYPVPREFIX)$(IOCNAME):D$(DIG):AD6:NDAttributesFile", "${TOP}/iocBoot/iocNCINDG-IOC-01/hdf5_attributes.xml"