sed -n '
s/"//g
s/^\.Se /Chapter /p
s/^\.Ah /	A. /p
s/^\.Bh /		B.  /p' $*
