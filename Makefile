#
#   $Id$
#
TOPDIR:=$(shell pwd)

TARGET=$(TOPDIR)/target
OUTPUT_TEX=$(TARGET)/tex
# PDFLATEXPARAM=-interaction=nonstopmode
# PDFLATEXPARAM=-recorder
PDFLATEXPARAM=


SOURCE_TEX=src/tex
SOURCE_XELATEX=src/xelatex
SOURCE_JAVA=src/java
SOURCE_SFD=src/sfd
SOURCE_OTF=src/otf
SOURCE_TTF=src/ttf
SOURCE_SCRIPT=src/scripts
SOURCE_FFSCRIPT=$(SOURCE_SFD)/scripts

OUTPUT_SFD=$(TARGET)/sfd
OUTPUT_TTF=$(TARGET)/ttf
OUTPUT_OTF=$(TARGET)/otf
OUTPUT_PFB=$(TARGET)/pfb
OUTPUT_JAVA=$(TARGET)/classes

TEXFILES=$(wildcard *.tex) $(wildcard $(SOURCE_XELATEX)/*.tex)
PDFTEXFILES=$(patsubst %.tex, $(OUTPUT_TEX)/%.pdf ,$(notdir $(TEXFILES)))

TEXINPUTS:=.:$(SOURCE_TEX):$(SOURCE_XELATEX):$(TEXINPUTS)
CLASSPATH:=$(TARGET)/classes:$(CLASSPATH)

SFDFILES=$(wildcard $(OUTPUT_SFD)/*.sfd)
TTFFILES=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_TTF)/%,  $(patsubst %.sfd, %.ttf ,$(SFDFILES)))
OTFFILES=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_OTF)/%,  $(patsubst %.sfd, %.otf ,$(SFDFILES)))
JAVAFILES=$(wildcard $(SOURCE_JAVA)/*.java)
CLASSFILES=$(patsubst $(SOURCE_JAVA)/%, $(OUTPUT_JAVA)/%,  $(patsubst %.java, %.class ,$(JAVAFILES)))


all: init version $(CLASSFILES) $(OUTPUT_TEX)/fxlglyphname.tex $(OUTPUT_TEX)/fxbglyphname.tex $(PDFTEXFILES)

$(OUTPUT_TEX)/test%.pdf : $(SOURCE_XELATEX)/test%.tex xelibertine.sty 
		xelatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<

$(OUTPUT_TEX)/%.pdf : %.tex xelibertine.sty $(OUTPUT_TEX)/LinLibertineAlias.tex $(OUTPUT_TEX)/fxlglyphname.tex
		xelatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<
		-test -f $(OUTPUT_TEX)/$(patsubst %.tex,%,$<).idx && ./splitindex.pl $(OUTPUT_TEX)/$(patsubst %.tex,%,$<) -- -g -s $(SOURCE_TEX)/index.ist && xelatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<		

$(OUTPUT_TEX)/LinLibertineAlias.tex : $(SOURCE_SFD)/LinLibertine.nam
		sh $(SOURCE_SCRIPT)/nam2alias $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_TEX)/LinLibertineAlias.tex

$(OUTPUT_JAVA)/%.class : $(SOURCE_JAVA)/%.java
		javac -d $(OUTPUT_JAVA) $<

$(OUTPUT_TEX)/fxlglyphname.tex : $(OUTPUT_OTF)/fxlr.otf $(CLASSFILES) $(SOURCE_SFD)/LinLibertine.nam
	fontforge -script $(SOURCE_FFSCRIPT)/sfdtopfb.pe $(OUTPUT_OTF)/fxlr.otf $(OUTPUT_PFB)/fxlr.pfb
	grep "^C " $(OUTPUT_PFB)/fxlr.afm | sed -e 's/\(.*\) N \(.*\) ; \(.*\)/\2/g' | sed -e 's/\([:alnum]*\) .*/\1/g' | sort > $(OUTPUT_TEX)/fxlglyphname.txt
	cat $(OUTPUT_TEX)/fxlglyphname.txt | sed -e 's/\(^.*\)/\\GYLPHNAME{\1}/g' > $(OUTPUT_TEX)/fxlglyphname.tex
	java -cp $(CLASSPATH) GroupGlyphs $(OUTPUT_TEX)/fxlglyphname.txt $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_TEX)/fxlgroupglyphs.tex

$(OUTPUT_TEX)/fxbglyphname.tex : $(OUTPUT_OTF)/fxbr.otf $(CLASSFILES) $(SOURCE_SFD)/LinBiolinum.nam
	fontforge -script $(SOURCE_FFSCRIPT)/sfdtopfb.pe $(OUTPUT_OTF)/fxbr.otf $(OUTPUT_PFB)/fxbr.pfb
	grep "^C " $(OUTPUT_PFB)/fxbr.afm | sed -e 's/\(.*\) N \(.*\) ; \(.*\)/\2/g' | sed -e 's/\([:alnum]*\) .*/\1/g' | sort > $(OUTPUT_TEX)/fxbglyphname.txt
	cat $(OUTPUT_TEX)/fxbglyphname.txt | sed -e 's/\(^.*\)/\\GYLPHNAME{\1}/g' > $(OUTPUT_TEX)/fxbglyphname.tex
	java -cp $(CLASSPATH) GroupGlyphs $(OUTPUT_TEX)/fxbglyphname.txt $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_TEX)/fxbgroupglyphs.tex

init:  
	@mkdir -p $(TARGET)
	@mkdir -p $(OUTPUT_TEX)
	@mkdir -p $(OUTPUT_SFD)
	@mkdir -p $(OUTPUT_TTF)
	@mkdir -p $(OUTPUT_OTF)
	@mkdir -p $(OUTPUT_PFB)
	@mkdir -p $(OUTPUT_JAVA)
	@sh $(SOURCE_SCRIPT)/fontName2LaTeX $(SOURCE_SFD) $(OUTPUT_SFD) sfd
	@sh $(SOURCE_SCRIPT)/fontName2LaTeX $(SOURCE_OTF) $(OUTPUT_OTF) otf
	@sh $(SOURCE_SCRIPT)/fontName2LaTeX $(SOURCE_TTF) $(OUTPUT_TTF) ttf

version:
	@rm -f $(OUTPUT_TEX)/version
	@touch $(OUTPUT_TEX)/version
	@find $(SOURCE_OTF)/ -name '*.otf' -exec basename {} .otf >>$(OUTPUT_TEX)/version \;
	@cat $(OUTPUT_TEX)/version | sort >$(OUTPUT_TEX)/versiontmp
	@mv $(OUTPUT_TEX)/versiontmp $(OUTPUT_TEX)/version

copysf: all
	scp xelibertine.sty mgn,linuxlibertine@web.sourceforge.net:htdocs/latex/
	scp $(OUTPUT_TEX)/xelibertineDoku.pdf mgn,linuxlibertine@web.sourceforge.net:htdocs/latex/

createCTAN:
	zip /tmp/xelibertine_CTAN.zip  xelibertine.sty 
	cd target/tex; zip /tmp/xelibertine_CTAN.zip  xelibertineDoku.pdf


copyfont:
	@rm -rf ~/.fonts/LinLibertine* ~/.fonts/Biolinum* ~/.fonts/fx*
	@cp -v $(OUTPUT_OTF)/fx*.otf ~/.fonts/
	@cp -v $(OUTPUT_TTF)/fx*.ttf ~/.fonts/

help:
	@grep -v "^#" Makefile.help

readme:
	@less Readme


cleantmp:
	-find . -name '*~' -type f -exec rm -f {} \;
	-find . -name '*.backup' -type f -exec rm -f {} \;
	-rm -f *.flc *.fls

clean: cleantmp
	-rm -rf $(TARGET)


