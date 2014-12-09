#	@(#) uutot.awk - display uucp statistics - requires new awk
#	@(#) Usage: awk -f uutot.awk [site ...] /usr/spool/uucp/.Admin/xferstats
#	Copyright 1989 Roger A. Cornelius (rac@sherpa.uucp)

#	dosome[];		# site names to work for - all if not set
#	remote[];		# array of site names
#	bytes[];		# bytes xmitted by site
#	time[];			# time spent by site
#	files[];		# files xmitted by site
BEGIN {
	doall = 1;
	if (ARGC > 2) {
		doall = 0;
		for (i = 1; i < ARGC-1; i++) {
			dosome[ ARGV[i] ];
			ARGV[i] = "";
		}
	}

	kbyte = 1024	# 1000 if you're not picky
	bang = "!";
	sending = "->";
	xmitting = "->" "|" "<-";

	hdr1 = "Remote     K-Bytes   K-Bytes   K-Bytes " \
		"Hr:Mn:Sc Hr:Mn:Sc AvCPS AvCPS    #    #\n";
	hdr2 = "SiteName      Recv      Xmit     Total     " \
		"Recv     Xmit  Recv  Xmit Recv Xmit\n";
	hdr3 = "-------- --------- --------- --------- -------- " \
		"-------- ----- ----- ---- ----";
	fmt1 = "%-8.8s %9.3f %9.3f %9.3f %2d:%02d:%02.0f " \
		"%2d:%02d:%02.0f %5.0f %5.0f %4d %4d\n";
	fmt2 = "Totals   %9.3f %9.3f %9.3f %2d:%02d:%02.0f " \
		"%2d:%02d:%02.0f %5.0f %5.0f %4d %4d\n";
}
{
	if ($6 !~ xmitting)		# should never be
		next;
	direction = ($6 == sending ? 1 : 2)

	site = substr($1,1,index($1,bang)-1);
	if (site in dosome || doall) {
		remote[site];
		bytes[site,direction] += $7;
		time[site,direction] += $9;
		files[site,direction]++;
	}
}
END {
	print hdr1 hdr2 hdr3;
	for (k in remote) {
		rbyte += bytes[k,2];	sbyte += bytes[k,1];
		rtime += time[k,2];		stime += time[k,1];
		rfiles += files[k,2];	sfiles += files[k,1];
		printf(fmt1, k, bytes[k,2]/kbyte, bytes[k,1]/kbyte,
			(bytes[k,2]+bytes[k,1])/kbyte,
			time[k,2]/3600, (time[k,2]%3600)/60, time[k,2]%60,
			time[k,1]/3600, (time[k,1]%3600)/60, time[k,1]%60,
			bytes[k,2] && time[k,2] ? bytes[k,2]/time[k,2] : 0,
			bytes[k,1] && time[k,1] ? bytes[k,1]/time[k,1] : 0,
			files[k,2], files[k,1]);
	}

	print hdr3
	printf(fmt2, rbyte/kbyte, sbyte/kbyte, (rbyte+sbyte)/kbyte,
		rtime/3600, (rtime%3600)/60, rtime%60,
		stime/3600, (stime%3600)/60, stime%60,
		rbyte && rtime ? rbyte/rtime : 0,
		sbyte && stime ? sbyte/stime : 0,
		rfiles, sfiles);
}
