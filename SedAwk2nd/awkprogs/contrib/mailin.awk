# SCCS = @(#) mailin.awk 1.2 2/15/90 15:47:39
BEGIN {
	msgno = ARGV[1]
	tmpfile = ARGV[2]
	ARGV[1] = ""
	ARGV[2] = ""
	}
{
if ($1 == "From" && NF == 8)
	{
	getline
	}
if ($1 == ">From")
	{
	filename="mail."msgno
	print "cat > " filename " << '@EOF " filename "'" > tmpfile
	print "From: " $2 >> tmpfile
	while (NF != 0)
		{
		getline
		if ($1 == "Date:")
			{
			print $0 >> tmpfile
			}
		if ($1 == "Subject:")
			{
			print $0 >> tmpfile
			}
		}
	print "--------------------" >> tmpfile
	getline
	while ($1 != "From" || NF != 8)
		{
		print $0 >> tmpfile
		if (getline == 0)
			{
			exit
			}
		}
	print "@EOF " filename >> tmpfile
	msgno = msgno + 1
	}
}


