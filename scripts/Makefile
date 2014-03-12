#
#  Makefile  to build TeX documents (using pdflatex and latex2html)
#
#  For Hall A OSP 
#  by  E.Chudakov gen@jlab.org
#  28 Apr 2003
#  Some code was taken from latex2html manual makefile

# Check the directory name
topdir  := $(shell /bin/pwd)
topdirsp := $(shell basename $(topdir))
#ifneq ($(topdirsp),run) 
#  $(error You should run this make in the "run" directory, created by Config XX X )
#endif

# Read the configuration file

ifeq (.config,$(wildcard .config))
  include .config
else
  $(error .config file is missing. Run Config XX X in the top directory )
endif

top := $(DOCNAME)
lev := $(INFOLEVEL)

srcdir := $(shell cd ../src ; pwd)
srcdir1 := $(strip $(srcdir))
fnam :=$(srcdir)/$(top)/main.tex
dirhtml := $(top)_html

scrdir := $(shell cd ../scripts ; pwd)
scrdir1 := $(strip $(scrdir))

# Name files: source and target
NAMCOM = $(scrdir1)/names.com
namesd := $(srcdir1)/people
namess := $(namesd)/names.txt
namest := $(namesd)/names.tex

#$(error File $(srcdir1))
#$(error wild $(fnam)=$(wildcard $(fnam)))

ifneq ($(fnam),$(wildcard $(fnam)))
  $(error File $(top) $(fnam) is missing) 
endif

dummy := $(shell cat $(srcdir1)/common/infolevel.tex | sed s"/infolevel{.}/infolevel{$(lev)}/" > currinfolevel.tex)
dummy := $(shell if [ $(INFOLEVEL) -lt 4 ]; then echo "\renewcommand{\infolevfour}[1]{}%" ; fi >> currinfolevel.tex)
dummy := $(shell if [ $(INFOLEVEL) -lt 3 ]; then echo "\renewcommand{\infolevthree}[1]{}%" ; fi >> currinfolevel.tex)
dummy := $(shell if [ $(INFOLEVEL) -lt 2 ]; then echo "\renewcommand{\infolevtwo}[1]{}%" ; fi >> currinfolevel.tex)
dummy := $(shell if [ $(INFOLEVEL) -lt 1 ]; then echo "\renewcommand{\infolevone}[1]{}%" ; fi >> currinfolevel.tex)
dummy := $(shell if [ $(INFOLEVEL) -gt 3 ]; then echo "\renewcommand{\infolevltfour}[1]{}%" ; fi >> currinfolevel.tex)
dummy := $(shell if [ $(INFOLEVEL) -gt 2 ]; then echo "\renewcommand{\infolevltthree}[1]{}%" ; fi >> currinfolevel.tex)
dummy := $(shell if [ $(INFOLEVEL) -gt 1 ]; then echo "\renewcommand{\infolevlttwo}[1]{}%" ; fi >> currinfolevel.tex)
dummy := $(shell if [ $(INFOLEVEL) -gt 0 ]; then echo "\renewcommand{\infolevltone}[1]{}%" ; fi >> currinfolevel.tex)
dummy := $(shell if [ $(INFOLEVEL) -ne 4 ]; then echo "\renewcommand{\infoleveqfour}[1]{}%" ; fi >> currinfolevel.tex)
dummy := $(shell if [ $(INFOLEVEL) -ne 3 ]; then echo "\renewcommand{\infoleveqthree}[1]{}%" ; fi >> currinfolevel.tex)
dummy := $(shell if [ $(INFOLEVEL) -ne 2 ]; then echo "\renewcommand{\infoleveqtwo}[1]{}%" ; fi >> currinfolevel.tex)
dummy := $(shell if [ $(INFOLEVEL) -ne 1 ]; then echo "\renewcommand{\infoleveqone}[1]{}%" ; fi >> currinfolevel.tex)
dummy := $(shell if [ $(INFOLEVEL) -ne 0 ]; then echo "\renewcommand{\infoleveqnull}[1]{}%" ; fi >> currinfolevel.tex)

#$(error .config dir= $(srcdir) lev=$(lev))
TEXINPUTS =.:$(srcdir1):$(srcdir1)/common:$(srcdir1)/$(top):
BIBINPUTS =$(TEXINPUTS)
BSTINPUTS =$(TEXINPUTS)

export TEXINPUTS BIBINPUTS BSTINPUTS


DVIPS = dvips  
LATEX = latex
PDFLATEX = pdflatex
MAKEINDEX = makeindex
BIBTEX = bibtex

#L2H = latex2html -no_math -html_version 3.2,math -accent_images textrm -dir $(top) 
#L2H = latex2html -no_math -html_version 3.2,math -accent_images textrm -toc_depth 6 -dir $(top) 
#L2H = l2ng  -no_math -html_version 4.0,math -scalable_fonts 

L2H = latex2html -no_math -html_version 4.0,math -accent_images textrm -scalable_fonts -mkdir -dir $(dirhtml)
L2Hframes = latex2html -no_math -html_version 4.0,math,frame -accent_images textrm -scalable_fonts 

#L2H = $(L2Hframes)

#L2Hno = $(L2H) -no_images
#L2Hon = $(L2H) -images_only

curdir 	:= $(shell pwd) 

#dirs := $(shell cat osp.tex | grep '\input{' | grep -v '^%' | grep '/' | sed s"#[{}/]# #"g | awk '{print $2}')
dirs := $(shell cat $(fnam) | grep '\input{' | grep -v '^%' | grep '/' | sed s"%[{}/]% %"g | \
           cut -d" " -f2)
# bibl := $(shell cat $(fnam) | grep 'bibliography' | grep -v '^%')
comfs := $(shell find ../src/common -type f | grep -v '~' )
#dirsg := $(shell for d in $(dirs); do echo $$d/figs ; done)
#figs1 := $(shell for i in $(dirsg); do a=`ls -1 -d $$i/*.*ps* 2>/dev/null` ; echo $$a ; done)
#figs2 := $(shell for i in $(dirsg); do a=`ls -1 -d $$i/*.jpg  2>/dev/null` ; echo $$a ; done)
#figs3 := $(shell for i in $(dirsg); do a=`ls -1 -d $$i/*.png  2>/dev/null` ; echo $$a ; done)
# $(error co $(bibl))
#

.PHONY	: clean
.PHONY	: pdf
none:	  pdf
clean:		
	echo Clean
	ls -1 $(top).* | grep -v '\.tex' | xargs rm -f
	if [ -d $(dirhtml) ]; then rm -r -f $(top) ; fi

aux:    $(top).aux
	pdf	

## Disable names.tex generation from src/people/names.txt
##   - src/people/names.txt is out of date, $(NAMCOM) should NOT be run
##   - names.tex is now the primary source file
#$(namest) : $(namess)
#	(cd $(namesd) ; $(NAMCOM))

pdf:	 clean $(namest)
	echo "Rerun-TEST" > $(top).log ; \
	ln -s -f $(fnam) $(top).tex ; \
	ln -s -f ../src/$(top)/title.tex . ; \
	$(PDFLATEX) $(top) ;\
	$(BIBTEX) $(top) 
	nrun=1; while [ ! -z "`sed -n '/Rerun-TEST/p' < $(top).log`" ] ; do \
	   echo Rerun ... ; \
	   $(PDFLATEX) $(top) ; \
	   nrun=`expr $$nrun + 1` ; \
	   if [ $$nrun -gt 5 ]; then echo 'Compiling document too often, something is wrong.'; exit 1; fi; \
	done ;  \
        if [ ! -z "`sed -n '/undefined references/p' < $(top).log`" ]; then \
            $(PDFLATEX) $(top) ; nrun=`expr $$nrun + 1` ; \
        fi ; \
	   $(PDFLATEX) $(top) ; \
	   nrun=`expr $$nrun + 1` ; \
	echo Finished at iteration $$nrun
	rm -f $(top).tex ; \
	rm -f title.tex 
#	if [ ! -z $(bibl) ]; then $(BIBTEX) $(top) ; else $(error $(bibl));fi
#	   $(PDFLATEX) $(top) > $(top).log1 ; \
.PHONY	: html
html:   
	ln -s -f $(fnam) $(top).tex
	ln -s -f ../src/$(top)/title.tex .
	for i in $(comfs); do \
	   ln -s -f $$i . ; \
	done
	rm -r -f $(dirhtml)
	for dir in $(dirs); do \
	   ln -s -f ../src/$$dir . ;\
	done
#	for i in $(figs1); do \
#	   ln -s -f $$i  ;\
#	done
#	for i in $(figs2); do \
#	   ln -s -f $$i  ;\
#	done
#	for i in $(figs3); do \
#	   ln -s -f $$i  ;\
#	done
	$(L2H) $(top).tex
	../scripts/html_img.com $(dirhtml) 
	rm -f $(top).tex  ;\
	rm -f title.tex  ;\
	for i in $(comfs); do \
	   j=`basename $$i` ; \
	   rm -f $$j ; \
	done
	for dir in $(dirs); do \
	   rm -f $$dir  ;\
	done
#	for i in $(figs1); do \
#	   j=`basename $$i` ; \
#	   rm $$j  ;\
#	done
#	for i in $(figs2); do \
#	   j=`basename $$i` ; \
#	   rm $$j  ;\
#	done
#	for i in $(figs3); do \
#	   j=`basename $$i` ; \
#	   rm $$j  ;\
#	done


