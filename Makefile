main:
	lualatex --shell-escape main.tex

all:
	make clean;
	lmake main.tex;
	make clean

clean:
	\rm -f main.log main.out main.aux main.toc main.idx main.ilg main.ind main.mtc* main.maf;
	\rm -f Recettes/**/main.tmp;
