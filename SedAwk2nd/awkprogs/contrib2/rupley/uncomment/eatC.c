/*
In article <16539@mimsy.UUCP>, chris@mimsy.UUCP (Chris Torek) writes:
In article <9864@megaron.arizona.edu> rupley@arizona.edu (John Rupley) writes:
>Score, anyone? (recent postings tested on K&R-I-syntax code)
>
>	sed        1/1 correct
>	Lex        2/2 correct
>	C          2/2 wrong

This sounds like a CHALLENGE!  :-)

I wrote the following working against the ten-minute spaghetti clock.
It is slightly tested, and probably works, with the exception of

	#include <some/*weird:file[syntax]>

(and unclosed comments, etc., in included files).  It is more
permissive than real C (allowing newlines in string and character
constants, and allowing infintely long character constants) but should
not get anything wrong that cpp gets right.

Of course, there are no comments in it. :-)
*/

#include <stdio.h>

enum states { none, slash, quote, qquote, comment, cstar };

main()
{
	register int c, q = 0;
	register enum states state = none;

	while ((c = getchar()) != EOF) {
		switch (state) {
		case none:
			if (c == '"' || c == '\'') {
				state = quote;
				q = c;
			} else if (c == '/') {
				state = slash;
				continue;
			}
			break;
		case slash:
			if (c == '*') {
				state = comment;
				continue;
			}
			state = none;
			(void) putchar('/');
			break;
		case quote:
			if (c == '\\')
				state = qquote;
			else if (c == q)
				state = none;
			break;
		case qquote:
			state = quote;
			break;
		case comment:
			if (c == '*')
				state = cstar;
			continue;
		case cstar:
			if (c != '*')
				state = c == '/' ? none : comment;
			continue;
		default:
			fprintf(stderr, "impossible state %d\n", state);
			exit(1);
		}
		(void) putchar(c);
	}
	if (state != none)
		fprintf(stderr, "warning: file ended with unterminated %s\n",
			state == quote || state == qquote ?
				(q=='"' ? "string" : "character constant") :
			"comment");
	exit(0);
}
/*
In-Real-Life: Chris Torek, Univ of MD Comp Sci Dept (+1 301 454 7163)
Domain:	chris@mimsy.umd.edu	Path:	uunet!mimsy!chris
*/

