PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')
RSCRIPT = Rscript --no-init-file

all: install

test:
	${RSCRIPT} -e 'library(methods); devtools::test()'

doc:
	${RSCRIPT} -e "library(methods); devtools::document()"

install:
	${RSCRIPT} -e "library(methods); devtools::install()"

build:
	${RSCRIPT} -e "library(methods); devtools::build()"

check:
	_R_CHECK_CRAN_INCOMING_=FALSE make check_all

check_all:
	${RSCRIPT} -e "library(methods); devtools::check(cran=TRUE)"

README.md: README.Rmd
	Rscript -e 'library(methods); devtools::load_all(); rmarkdown::render("README.Rmd", output_file="README.md")'
	sed -i.bak 's/[[:space:]]*$$//' $@
	rm -f $@.bak

.PHONY: all test doc install check check_all
