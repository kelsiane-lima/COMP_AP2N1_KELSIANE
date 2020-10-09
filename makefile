all : arquivo.l arquivo.y
	clear
	flex -i arquivo.l
	bison arquivo.y
	gcc arquivo.tab.c -o analisador -lm
	./analisador
