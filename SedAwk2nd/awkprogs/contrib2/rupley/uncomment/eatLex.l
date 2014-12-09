%{
/*
 * UNCOMMENT.l
 *
 * John Rupley 
 *
 * uucp: ..{uunet | ucbvax | cmcl2 | hao!ncar!noao}!arizona!rupley!local 
 * internet: rupley!local@cs.arizona.edu 
 * (H) 30 Calle Belleza, Tucson AZ 85716 - (602) 325-4533 
 * (O) Dept. Biochemistry, Univ. Arizona, Tucson AZ 85721 - (602) 621-3929 
 *
 * long strings (with escaped newlines) blow yytext[YYLMAX]; 
 * 	this is a feature, not a bug.
 */
%}
STRING		\"(\\\n|\\\"|[^"\n])*\"
COMMENTBODY	([^*\n]|"*"+[^*/\n])*
COMMENTEND	([^*\n]|"*"+[^*/\n])*"*"*"*/"
QUOTECHAR	\'[^\\]\'|\'\\.\'|\'\\[x0-9][0-9]*\'
ESCAPEDCHAR	\\.
%START	COMMENT
%%
<COMMENT>{COMMENTBODY}		;
<COMMENT>{COMMENTEND}		BEGIN 0;
<COMMENT>.|\n			;
"/*"				BEGIN COMMENT;
{STRING}			ECHO;
{QUOTECHAR}			ECHO;
{ESCAPEDCHAR}			ECHO;
.|\n				ECHO;

