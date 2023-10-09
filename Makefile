PAPER = paper
TEX = $(wildcard *.tex src/*.tex)
BIB = paper.bib
FIGS =
PLOTS	=

.SUFFIXES: .plot .eps .fig .png .pdf

all: graphs figures $(PAPER).pdf

graphs: $(addprefix plots/, $(addsuffix .pdf, $(PLOTS)))

figures: $(addprefix figures/, $(addsuffix .pdf, $(FIGS)))

$(PAPER).aux: $(TEX)
	pdflatex $(PAPER).tex

$(PAPER).bbl: $(PAPER).aux $(PAPER).bib
	bibtex $(PAPER)

$(PAPER).pdf: $(TEX) $(PAPER).bbl
	pdflatex $(PAPER).tex
	pdflatex $(PAPER).tex

clean:
	rm -f *.aux *.bbl *.blg *.log *.out $(PAPER).pdf *.fdb_latexmk *.fls

BASE ?= 8d8a2
#BASE ?= sec24summer
#BASE ?= ee91ff3
HEAD ?= HEAD

BASE_SHORT ?= $(shell git rev-parse --short ${BASE})
HEAD_SHORT ?= --

# (1) clone https://gitlab.com/git-latexdiff/git-latexdiff
# (2) cd git-latexdiff && make && make install
# (3) run 'make diff BASE=<version you want to compare against>'
diff::
	git latexdiff --main ${PAPER}.tex --latexmk  \
		${BASE_SHORT} ${HEAD_SHORT} \
		-o ${PAPER}-diff.pdf \
		--ignore-latex-errors --view	\
		--exclude-safecmd="todo,update,am,as,ml,mis,cite,textcolor"


.PHONY: all clean
