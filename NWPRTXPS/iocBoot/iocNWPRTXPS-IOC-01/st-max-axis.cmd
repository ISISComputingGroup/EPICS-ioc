# Find the maximum active axis number
stringiftest("ACTIVE", "$(AXIS$(MN)_ID=)",1)
$(IFACTIVE) calc("NAXES", "$(MN)", 1, 0)
