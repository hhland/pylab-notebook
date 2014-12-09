TEST=uncomment.tst2

eatC:	eatC.c
	cc -O eatC.c -o eatC

eatLex:	eatLex.l
	lex eatLex.l
	cc -O lex.yy.c -ll -o eatLex
	rm lex.yy.c

test.C: eatC
	eatC <$(TEST) >test.C

test.Lex: eatLex
	eatLex <$(TEST) >test.Lex

test.sed: 
	sed -n -f eatSed <$(TEST) >test.sed

timetest:
	timex eatC <$(TEST) >/dev/null
	timex eatLex <$(TEST) >/dev/null
	timex sed -n -f eatSed <$(TEST) >/dev/null

test: test.C test.Lex test.sed
	sum test.C test.Lex test.sed
	wc eatC.c eatLex.l eatSed
	make TEST=$(TEST) timetest

clean:
	rm -f test.C test.Lex test.sed

spotless: clean
	rm -f lex.yy.c eatC eatLex

