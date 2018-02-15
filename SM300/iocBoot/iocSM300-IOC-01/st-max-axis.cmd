# Find the maximum active axis number
stringiftest("ACTIVE", "$(AXIS$(MN)=)",5,"yes")
$(IFACTIVE) calc("NAXES", "$(MN)", 1, 0)
