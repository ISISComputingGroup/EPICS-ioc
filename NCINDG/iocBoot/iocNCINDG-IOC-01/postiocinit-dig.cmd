iocshLoad "hdf5-files.cmd" "DIG=$(DIG),ADET=1,FILENAME=DC$(DIG),FTEMPLATE=%s%s_DC$(DIG).h5"
iocshLoad "hdf5-files.cmd" "DIG=$(DIG),ADET=2,FILENAME=TRACE$(DIG),FTEMPLATE=%s%s_TRACE$(DIG).h5"
iocshLoad "hdf5-files.cmd" "DIG=$(DIG),ADET=3,FILENAME=TOF$(DIG),FTEMPLATE=%s%s_TOF$(DIG).h5"

stringiftest("DIG0", "$(DIG=)", 5, "0")

$(IFDIG0) iocshLoad "hdf5-files.cmd" "DIG=$(DIG),ADET=4,FILENAME=DC,FTEMPLATE=%s%s_DC.h5"
$(IFDIG0) iocshLoad "hdf5-files.cmd" "DIG=$(DIG),ADET=5,FILENAME=TRACE,FTEMPLATE=%s%s_TRACE.h5"
$(IFDIG0) iocshLoad "hdf5-files.cmd" "DIG=$(DIG),ADET=6,FILENAME=TOF,FTEMPLATE=%s%s.nxs_v2ext"
