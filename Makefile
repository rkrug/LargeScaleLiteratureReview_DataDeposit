## All Rmarkdown files in the working directory

SRCDIR := source
OUTDIR := docs

PLANTUML  := $(wildcard $(SRCDIR)/*.plantuml)

RMD  := $(wildcard $(SRCDIR)/*.Rmd)

HTML := $(RMD:.Rmd=.html)
HTML := ${subst $(SRCDIR),$(OUTDIR),$(HTML)}

PDF  := $(RMD:.Rmd=.pdf)
PDF := ${subst $(SRCDIR),$(OUTDIR),$(PDF)}

all: clean figs html

############# figs #############

figs: 
	plantuml $(PLANTUML) -o figs
	plantuml $(PLANTUML) -tsvg -o figs
	
clean_figs:
	rm -rf figs

############# html #############

html:	$(HTML)

$(OUTDIR)/%.html: $(SRCDIR)/%.Rmd
	@Rscript -e "rmarkdown::render('$<', output_dir = './$(OUTDIR)/', output_format = 'html_document')"

clean_html:
	rm -f $(HTML)

############# pdf #############

pdf:	$(PDF)

$(OUTDIR)/%.pdf: $(SRCDIR)/%.Rmd
	@Rscript -e "rmarkdown::render('$<', output_dir = './$(OUTDIR)/', output_format = 'pdf_document')"

clean_pdf:
	rm -f $(PDF)

############# Help targets #############

clean: clean_pdf clean_html clean_figs

############# Help targets #############

list_variables:
	@echo
	@echo "#############################################"
	@echo "## Variables ################################"
	@make -pn | grep -A1 "^# makefile"| grep -v "^#\|^--" | sort | uniq
	@echo "#############################################"
	@echo ""

## from https://stackoverflow.com/a/26339924/632423
list_targets:
	@echo
	@echo "#############################################"
	@echo "## Targets    ###############################"
	@make -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo "#############################################"
	@echo

list: list_variables list_targets

.PHONY: list clean clean_pdf clean_html clean_figs figs all
