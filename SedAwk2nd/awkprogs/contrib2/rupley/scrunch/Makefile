PROCESSOR = iAPX286	#set for your hardware, as required by stdio.h

lex.yy.c scrunchLex:	scrunchLex.l
	lex scrunchLex.l
	cc -O lex.yy.c -ll -o scrunchLex

scrunch.cpp: lex.yy.c
	/lib/cpp -D$(PROCESSOR) lex.yy.c >scrunch.cpp

scrunch.cpp.c test.Lex: scrunchLex scrunch.cpp
	scrunchLex <scrunch.cpp >scrunch.cpp.c
	cc -O scrunch.cpp.c -ll
	-cmp -l a.out scrunchLex	#should give date/name diffs only

test test.awk: scrunch.cpp.c
	scrunchAwk <scrunch.cpp |diff - scrunch.cpp.c

clean:
	rm -f scrunch.cpp.c a.out scrunchLex scrunch.cpp lex.yy.c

