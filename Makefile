#
#   $Id$
#
TOPDIR:=$(shell pwd)

TARGET=$(TOPDIR)/target
OUTPUT_TEX=$(TARGET)/tex
# PDFLATEXPARAM=-interaction=nonstopmode
# PDFLATEXPARAM=-recorder
PDFLATEXPARAM=

TEXFILES=$(wildcard *.tex)
#PDFTESTFILES=$(patsubst %.tex, $(OUTPUT_TEX)/%.pdf ,$(TESTFILES))
PDFTEXFILES=$(patsubst %.tex, %.pdf ,$(TEXFILES))

SOURCE_TEX=src/tex
SOURCE_SFD=src/sfd
SOURCE_OTF=src/otf
SOURCE_SCRIPT=src/scripts
SOURCE_FFSCRIPT=$(SOURCE_SFD)/scripts

OUTPUT_SFD=$(TARGET)/sfd
OUTPUT_TTF=$(TARGET)/ttf
OUTPUT_OTF=$(TARGET)/otf
OUTPUT_PFB=$(TARGET)/pfb

TEXINPUTS:=.:$(SOURCE_TEX):$(TEXINPUTS)

SFDFILES=$(wildcard $(OUTPUT_SFD)/*.sfd)
TTFFILES=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_TTF)/%,  $(patsubst %.sfd, %.ttf ,$(SFDFILES)))
OTFFILES=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_OTF)/%,  $(patsubst %.sfd, %.otf ,$(SFDFILES)))

all: init version $(PDFTEXFILES) $(OUTPUT_PFB)/fxlr.pfb

#$(OUTPUT_TEX)/%.pdf : %.tex libertinexe.sty
%.pdf : %.tex libertinexe.sty $(OUTPUT_TEX)/LinLibertineAlias.tex
		xelatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<

$(OUTPUT_TEX)/LinLibertineAlias.tex : $(SOURCE_SFD)/LinLibertine.nam
		sh $(SOURCE_SCRIPT)/nam2alias $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_TEX)/LinLibertineAlias.tex

$(OUTPUT_PFB)/fxlr.pfb : $(OUTPUT_OTF)/fxlr.otf
	@fontforge -script $(SOURCE_FFSCRIPT)/sfdtopfb.pe $< $(OUTPUT_PFB)/$(notdir $@)
	@grep "^C " $(OUTPUT_PFB)/fxlr.afm | sed -e 's/\(.*\) N \(.*\) ; \(.*\)/\2/g' | sed -e 's/\([:alnum]*\) .*/\1/g' | sort | sed -e 's/\(^.*\)/\\GYLPHNAME{\1}/g' > $(OUTPUT_TEX)/glyphname.tex 

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
	@mkdir -p $(OUTPUT_TEX)
	@mkdir -p $(OUTPUT_SFD)
	@mkdir -p $(OUTPUT_TTF)
	@mkdir -p $(OUTPUT_OTF)
	@mkdir -p $(OUTPUT_PFB)
	@sh $(SOURCE_SCRIPT)/fontName2LaTeX $(SOURCE_SFD) $(OUTPUT_SFD) sfd
	@sh $(SOURCE_SCRIPT)/fontName2LaTeX $(SOURCE_OTF) $(OUTPUT_OTF) otf

version:
	@rm -f $(OUTPUT_TEX)/version
	@touch $(OUTPUT_TEX)/version
	@find $(SOURCE_OTF)/ -name '*.otf' -exec basename {} .otf >>$(OUTPUT_TEX)/version \;


help:
	grep -v "^#" Makefile.help

readme:
	less Readme


cleantmp:
	-find . -name '*~' -type f -exec rm -f {} \;
	-find . -name '*.backup' -type f -exec rm -f {} \;
	-rm -f *.flc *.fls *.pdf

clean: cleantmp
	-rm -rf $(TARGET)


