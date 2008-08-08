#
#   $Id$
#
TOPDIR:=$(shell pwd)

TARGET=$(TOPDIR)/target
TEXOUTPUT=$(TARGET)/tex
# PDFLATEXPARAM=-interaction=nonstopmode
PDFLATEXPARAM=-recorder

TEXFILES=$(wildcard *.tex)
#PDFTESTFILES=$(patsubst %.tex, $(TEXOUTPUT)/%.pdf ,$(TESTFILES))
PDFTEXFILES=$(patsubst %.tex, %.pdf ,$(TEXFILES))

SOURCE_TEX=src/tex
SOURCE_SFD=src/sfd
SOURCE_OTF=src/otf
SOURCE_SCRIPT=src/scripts
SOURCE_FFSCRIPT=$(SOURCE_SFD)/scripts

OUTPUT_SFD=$(TARGET)/sfd
OUTPUT_TTF=$(TARGET)/ttf
OUTPUT_OTF=$(TARGET)/otf

TEXINPUTS:=.:$(SOURCE_TEX):$(TEXINPUTS)

SFDFILES=$(wildcard $(OUTPUT_SFD)/*.sfd)
TTFFILES=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_TTF)/%,  $(patsubst %.sfd, %.ttf ,$(SFDFILES)))
OTFFILES=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_OTF)/%,  $(patsubst %.sfd, %.otf ,$(SFDFILES)))

all: init $(PDFTEXFILES)

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
	@sh $(SOURCE_SCRIPT)/fontName2LaTeX $(SOURCE_SFD) $(OUTPUT_SFD) sfd
	@sh $(SOURCE_SCRIPT)/fontName2LaTeX $(SOURCE_OTF) $(OUTPUT_OTF) otf



cleantmp:
	-rm -f *~ *.flc *.backup *.fls *.pdf

clean: cleantmp
	-rm -rf $(TARGET)


