%{
/*-
 * SCRUNCH.l
 *
 * Scrunch cpp output to make it more readable.
 * 
 * Compress runs of "#" lines and blank lines, or runs of two or more
 * blank lines:
 * 	(\n*# lineno "file"\n+)+  or  \n\n\n+
 * into a single line:
 *	# lineno "file"\n
 * which is output before the next line of program text 
 * (corresponding to line "lineno" of the source "file").
 * The values of "lineno" and "file" are adjusted for changes in
 * source resulting from #include statements.
 *
 * Compilation:
 *	lex scrunch.l
 *	cc -O lex.yy.c -ll -o scrunch
 *
 * Minimally tested with UNIX sys5r2 cpp only, as follows:
 * (a)	/lib/cpp -Dprocessor=1 lex.yy.c >scruch.cpp	#specify your processor
 *	scrunch <scrunch.cpp >scrunch.cpp.c
 *	cc -O scrunch.cpp.c -ll
 *	cmp -l a.out scrunch		#should give date/name diffs only
 * (b)	compare line numbers in scrunch.cpp.c with lex.yy.c and scrunch.cpp
 *		(no differences stood out)
 *
 * John Rupley
 * rupley!local@cs.arizona.edu
 */
%}
	char f[80]; int x;
W	[ \t]*\n
%%
#.+\n		{sscanf(yytext,"#%d%s",&yylineno,f); x++;}
{W}/{W}|#	x++;
{W}		if(!x) ECHO;
.+\n		{if(x) printf("# %d %s\n",yylineno-1,f); ECHO; x=0;}
