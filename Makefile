all:run

lex:yacc 
	lex apron_c.l
yacc:
	yacc -d apron_c.y
tot:lex
	cc lex.yy.c y.tab.c -o bas.exe
run:tot
	./bas.exe <file.txt
clean:
	rm -f *.c *.h *.exe
