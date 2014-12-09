#\- awk script file, to build and execute an nroff command; run by roff
#where roff executes this script:      awk -f roff.awk "DDD=$*"
#usage: %[pipe commands|] roff [-Rlong.man.lp.lp1...etc] [-opts] [files]
#NOTE: printer setup and options are specific for local system
#j.a. rupley, tucson, arizona
#rupley!local@cs.arizona.edu

BEGIN		{
$0 = DDD
if ($1 ~ /\?/ || $1 ~ /help/) {
print "usage: [pipe commands|] roff [-Rroff_options_string] [-opts] [files]"
print ""
print "if the first argument begins with a \"-R\", the word is checked for"
print "a match to one or more of the following strings, which produces the"
print "associated action:"
print "	man	-can		default = -cm"
print "	rup	-rW53		default = -rW65   | rup => note-size paper"
print "		-rL63		default = -rL66   |"
print "	long	-rL100"
print "	lp | lp0 | pap		dev1 = | lp -onroff	|"
print "	lp1 | daisy | ua	dev1 = 1>/dev/daisy	| default = /dev/crt"
print "	null			dev2 = 2>/dev/null	|"
print "	eqn | tbl		preprocess nroff input"
print "	raw			turn off all default settings (except /dev/crt)"
print "	verbose			show the built-up nroff command line(s)"
print "	debug			show the command, but do NOT execute it"
print "	if(dev1 == crt)	postprocess nroff output with \"col -b\""
print "	if(dev1 == daisy) setup with lptron, -T450, -s & -rO0 (default = -rO8)"
print "	if(dev1 == lp) pipe output to epson spooler ( | lp -onroff)"
print "-options: handled in the usual way; override default or above settings;"
print "		applied as appropriate to \"nroff\" or \"lp\" commands"
print "input may be from a pipe or from a command-line filelist"
print "\"help\" or \"?\" produces this message"
	exit
}

if ($1 ~ /^-R.+/) {
	temp = $1
	start = 2
} else {
	temp = ""
	start = 1
}

command = "nroff"

if (temp !~ /raw/) {
	opt["-c"] = " -cm"
	opt["-rN"] = " -rN2"
	opt["-rL"] = " -rL66"
	opt["-rW"] = " -rW65"
	opt["-rO"] = " -rO8"
	if (temp) {
		if (temp ~ /rup/) {opt["-rW"] = " -rW53";opt["-rL"] = " -rL63"}
		if (temp ~ /man/) {opt["-c"] = " -can"}
		if (temp ~ /long/) {opt["-rL"] = " -rL100"}
	}
}

if (temp) {
	if (temp ~ /pap/ || temp ~ /lp/ || temp ~ /lp0/) {dev1 = " | lp -onroff"}
	if (temp ~ /lp1/ || temp ~ /daisy/ || temp ~ /ua/) {dev1 = " 1>/dev/daisy"}
	if (temp ~ /nul/) {dev2 = " 2>/dev/null"}
	if (temp ~ /eqn/ || temp ~ /tbl/) {command = "pic | tbl | neqn | " command}
}

if (dev1 ~ /daisy/) {
	opt["-rO"] = " -rO0"
	opt["-s"] = " -s"
	post = ""
	opt["-T"] = " -T450";
	setup = "/bin/lpset /dev/daisy 0 80 66 on 2>/dev/null 1>/dev/null"
	reset = "/bin/lpset /dev/daisy 0 80 66 2>/dev/null 1>/dev/null"
} else if (dev1 ~ /lp/) {
	opt["-T"] = " -Tepson";
	post = ""
	setup = ""
	reset = ""
} else {
	opt["-T"] = " -Tepson";
	post = " | col -b"
	setup = ""
	reset = ""
}

lpopt = ""
for(i = start; i <= NF; i++) {
	if ($i ~ /^-[ckm]/) {opt["-c"] = " " $i}
	else if ($i ~ /^-r/) {aaa = substr($i,1,3);opt[aaa] = " " $i}
	else if ($i ~ /^-o[0-9]/) {aaa = substr($i,1,2);opt[aaa] = " " $i}
	else if ($i ~ /^-[od]/) {lpopt = lpopt " " $i}
	else if ($i ~ /^-.*/) {aaa = substr($i,1,2);opt[aaa] = " " $i}
	else if ($i !~ /^-/) {break}
}

dev1 = dev1 lpopt

for (j in opt)
	command = command opt[j]

#cat filelist given on command line into nroff command contstruct;
#if no filelist, cat connects input pipe to command construct.
if (i <= NF) {
	precat = "cat"
	for (;i <=NF; i++)
		precat = precat " " $i
	command = precat " | " command
}

command = command post dev2 dev1

if (temp ~ /debug/ || temp ~ /verb/) {
	print $0
	print ""
	if (setup) print setup
	print command
	if (reset) print reset
}
if (temp !~ /debug/) {
	if (setup) system(setup)
	system(command)
	if (reset) system(reset)
}
}	#end BEGIN section

#absence of awk body section simplifies handling of optionally
#either input from filelist or from pipe
