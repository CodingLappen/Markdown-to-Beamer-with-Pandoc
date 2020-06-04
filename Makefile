CC	    := pdflatex
TARGETS := main
TEMP	  := $(addsuffix .tmp , $(TARGETS))
COPY		:= $(addsuffix .md , $(TEMP))
MAINS		:= $(addsuffix .tex, $(TEMP))
OBJ			:= talk.tex $(MAINS)
DEPS		:= 
NOT_MAIN:= $(filter-out $(MAINS), $(OBJ))

all: $(COPY) $(OBJ) $(TARGETS)

clean: 
	rm -f $(subst .tmp,,$(MAINS)).tex $(OBJ) *.snm *.toc *.out *.log *.nav *.aux $(COPY) *.pdf

$(COPY): %.tmp.md : %.md $(DEPS)
	cp $< $@
	$(foreach var ,  $(NOT_MAIN), echo "\input{$(var)}" >> $(COPY) ;)

$(NOT_MAIN): %.tex : %.md $(DEPS)
	pandoc $< --slide-level 2 -t beamer -o $@ 
	
$(MAINS): %.tex : %.md $(DEPS)
	pandoc $< --template=default.beamer --slide-level 2 -o $(MAINS)

$(TARGETS):  $(MAINS) 
	mv $< $(subst .tmp,,$<)
	pdflatex -interaction nonstopmode $(subst .tmp,,$<)
	pdflatex -interaction nonstopmode $(subst .tmp,,$<)
