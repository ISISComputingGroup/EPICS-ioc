iocshLoad "hdf5-files.cmd" "DIG=$(DIG),ADET=1,FTEMPLATE=%s%s_DC$(DIG).h5"
iocshLoad "hdf5-files.cmd" "DIG=$(DIG),ADET=2,FTEMPLATE=%s%s_TRACE$(DIG).h5"
iocshLoad "hdf5-files.cmd" "DIG=$(DIG),ADET=3,FTEMPLATE=%s%s_TOF$(DIG).h5"

stringiftest("DIG0", "$(DIG=)", 5, "0")

$(IFDIG0) iocshLoad "hdf5-files.cmd" "DIG=$(DIG),ADET=4,FTEMPLATE=%s%s_DC.h5"
$(IFDIG0) iocshLoad "hdf5-files.cmd" "DIG=$(DIG),ADET=5,FTEMPLATE=%s%s_TRACE.h5"
$(IFDIG0) iocshLoad "hdf5-files.cmd" "DIG=$(DIG),ADET=6,FTEMPLATE=%s%s.nxs_v2ext"
