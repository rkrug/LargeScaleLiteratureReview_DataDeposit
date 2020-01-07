## All Rmarkdown files in the working directory

SRCDIR = source
OUTDIR = docs

RMD := $(wildcard $(SRCDIR)/*.Rmd)

# HTML := $(RMD:.Rmd=.html)
TMP  := $(RMD:.Rmd=.html)
HTML := ${subst $(SRCDIR),$(OUTDIR),$(TMP)}

all: clean html

html:	$(HTML)

# %.html: %.Rmd
$(OUTDIR)/%.html: $(SRCDIR)/%.Rmd
	@Rscript -e "rmarkdown::render('$<', output_dir = './$(OUTDIR)/')"

clean:
	rm -f $(HTML)

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

.PHONY: list clean all
