all:run

lex:yacc 
	flex apron_c.l
yacc:
	bison -d apron_c.y
tot:lex
	cc lex.yy.c apron_c.tab.c -o bas.exe
run:tot
	./bas.exe <file.txt
clean:
	rm -f *.c *.h *.exe
