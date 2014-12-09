>From peckham@svax.cs.cornell.edu Fri Mar 24 10:03:21 1989
Path: arizona!noao!ncar!mailrus!cornell!peckham
From: peckham@svax.cs.cornell.edu (Stephen Peckham)
Newsgroups: comp.lang.c
Subject: Scrunch blank lines
Message-ID: <26389@cornell.UUCP>
Date: 24 Mar 89 17:03:21 GMT
References: <7150@siemens.UUCP> <9900010@bradley> <4896@cbnews.ATT.COM> <16078@cup.portal.com> <16492@mimsy.UUCP> <620@gonzo.UUCP>
Sender: nobody@cornell.UUCP
Reply-To: peckham@svax.cs.cornell.edu (Stephen Peckham)
Distribution: na
Organization: Cornell Univ. CS Dept, Ithaca NY
Lines: 22

In article <620@gonzo.UUCP> daveb@gonzo.UUCP (Dave Brower) writes:
>So, I offer this week's challenge:  Smallest program that will take
>"blank line" style cpp output on stdin and send to stdout a scrunched
>version with appropriate #line directives.  [f]lex, Yacc, [na]awk, sed,
>perl, c, c++ are all acceptable.  This will be an amusing excercise in
>typical text massaging that can be enlightening for many people.
>
Here's an awk program that will do the trick.  Single blank lines are left as
is.  Multiple blank lines are removed, and a new line directive is added.

{if (NF == 0) blanks++
 else if ($1=="#") {l_no = $2-1; f = $3; blanks = 2;}
 else {
	if (blanks > 1) print "#", l_no, f;
	else if (blanks == 1) print "";
	blanks = 0;
	print $0;
      }
 l_no++;
}	

Steve Peckham



