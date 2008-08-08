#
#   $Id$
#
TOPDIR:=$(shell pwd)

TARGET=$(TOPDIR)/target
TEXOUTPUT=$(TARGET)/tex
# PDFLATEXPARAM=-interaction=nonstopmode
PDFLATEXPARAM=-recorder

TESTFILES=$(wildcard test*.tex)
#PDFTESTFILES=$(patsubst %.tex, $(TEXOUTPUT)/%.pdf ,$(TESTFILES))
PDFTESTFILES=$(patsubst %.tex, %.pdf ,$(TESTFILES))

SOURCE_SFD=src/sfd
SOURCE_SCRIPT=src/scripts
SOURCE_FFSCRIPT=$(SOURCE_SFD)/scripts

OUTPUT_SFD=$(TARGET)/sfd
OUTPUT_TTF=$(TARGET)/ttf
OUTPUT_OTF=$(TARGET)/otf

SFDFILES=$(wildcard $(OUTPUT_SFD)/*.sfd)
TTFFILES=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_TTF)/%,  $(patsubst %.sfd, %.ttf ,$(SFDFILES)))
OTFFILES=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_OTF)/%,  $(patsubst %.sfd, %.otf ,$(SFDFILES)))

all: init $(PDFTESTFILES)

#$(TEXOUTPUT)/%.pdf : %.tex libertinexe.sty
%.pdf : %.tex libertinexe.sty $(TEXOUTPUT)/LinLibertineAlias.tex
		xelatex $(PDFLATEXPARAM) -output-directory=$(TEXOUTPUT) $<

$(TEXOUTPUT)/LinLibertineAlias.tex : LinLibertine.nam
		sh $(SOURCE_SCRIPT)/nam2alias LinLibertine.nam $(TEXOUTPUT)/LinLibertineAlias.tex

#ttf: init $(TTFFILES)

#otf: init $(OTFFILES)

#$(OUTPUT_TTF)/%.ttf : $(OUTPUT_SFD)/%.sfd
#	@echo -e "\n" $<
#	@nice fontforge -script $(SOURCE_FFSCRIPT)/sfdtottf.pe $< $(OUTPUT_TTF)/$(notdir $@)

#$(OUTPUT_OTF)/%.otf : $(OUTPUT_SFD)/%.sfd
#	@echo -e "\n" $<
#	@nice fontforge -script $(SOURCE_FFSCRIPT)/sfdtootf.pe $< $(OUTPUT_OTF)/$(notdir $@)


init:
	@mkdir -p $(TARGET)
	@mkdir -p $(TEXOUTPUT)/tex
	@mkdir -p $(TARGET)/sfd
	@mkdir -p $(TARGET)/ttf
	@mkdir -p $(TARGET)/otf
	#@sh $(SOURCE_SCRIPT)/fontName2LaTeX $(SOURCE_SFD) $(OUTPUT_SFD)



cleantmp:
	-rm -f *~ *.flc *.backup *.fls *.pdf

clean: cleantmp
	-rm -rf $(TEXOUTPUT)


