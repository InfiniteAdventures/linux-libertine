#
#   $Id$
#
TOPDIR:=$(shell pwd)
FONT=libertine

TARGET=$(TOPDIR)/target
OUTPUT_TEX=$(TARGET)/tex
# PDFLATEXPARAM=-interaction=nonstopmode
# PDFLATEXPARAM=-recorder
PDFLATEXPARAM=

TEXMF_MAIN:=$(shell kpsewhich -expand-var='$$TEXMFLOCAL')
MYTEXMF_LOCAL=/usr/local/share/texmf
TL2008:=/usr/local/texlive/2008

SOURCE_TEX=src/tex
SOURCE_XELATEX=src/test/xelatex
SOURCE_LATEX=src/test/latex
SOURCE_FONTINST=src/fontinst
SOURCE_DOKU=src/doku
SOURCE_JAVA=src/java
SOURCE_SFD=src/sfd
SOURCE_OTF=src/otf
SOURCE_TTF=src/ttf
SOURCE_ENC=src/enc
SOURCE_SCRIPT=src/scripts
SOURCE_FFSCRIPT=$(SOURCE_SFD)/scripts
SOURCE_DPKG=src/dpkg

OUTPUT_SFD=$(TARGET)/sfd
OUTPUT_TTF=$(TARGET)/ttf
OUTPUT_OTF=$(TARGET)/otf
OUTPUT_PFB=$(TARGET)/pfb
OUTPUT_ENC=$(TARGET)/enc
OUTPUT_JAVA=$(TARGET)/classes
OUTPUT_DIST=$(TARGET)/dist

TEXFILES=$(wildcard *.tex) $(wildcard $(SOURCE_XELATEX)/*.tex) $(wildcard $(SOURCE_LATEX)/*.tex)
PDFTEXFILES=$(patsubst %.tex, $(OUTPUT_TEX)/%.pdf ,$(notdir $(TEXFILES)))


SFDFILES=$(wildcard $(OUTPUT_SFD)/*.sfd)
TTFFILES=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_TTF)/%,  $(patsubst %.sfd, %.ttf ,$(SFDFILES)))
OTFFILES=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_OTF)/%,  $(patsubst %.sfd, %.otf ,$(SFDFILES)))
PFBFILES=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_PFB)/%,  $(patsubst %.sfd, %.pfb ,$(SFDFILES)))

ENCFILES=$(wildcard $(OUTPUT_ENC)/x*.enc)
ETXFILES=$(patsubst %.enc, $(OUTPUT_TEX)/%.etx,  $(notdir $(ENCFILES)))

AFMFILES=$(wildcard $(OUTPUT_PFB)/fx*.afm)
MTXFILES=$(patsubst $(OUTPUT_PFB)/%, $(OUTPUT_TEX)/%,  $(patsubst %.afm, %-8r.mtx ,$(AFMFILES)))

CREATEFILES=$(wildcard $(SOURCE_FONTINST)/create_*.tex)
XCREATEFILES=$(patsubst $(SOURCE_FONTINST)/%, $(OUTPUT_TEX)/%,  $(patsubst %.tex, %.create ,$(CREATEFILES)))


JAVAFILES=$(wildcard $(SOURCE_JAVA)/*.java)
CLASSFILES=$(patsubst $(SOURCE_JAVA)/%, $(OUTPUT_JAVA)/%,  $(patsubst %.java, %.class ,$(JAVAFILES)))

TEXINPUTS:=.:$(OUTPUT_TEX):$(SOURCE_FONTINST):$(SOURCE_TEX):$(SOURCE_XELATEX):$(OUTPUT_ENC):$(OUTPUT_PFB):$(SOURCE_TEX)/babel:$(SOURCE_DOKU):$(TEXINPUTS)
CLASSPATH:=$(TARGET)/classes:lib/fontwareone.jar:$(CLASSPATH)


all: init version $(CLASSFILES)  $(PDFTEXFILES)

pfb: init $(PFBFILES) $(OUTPUT_ENC)/xl-00.enc $(OUTPUT_ENC)/xb-00.enc $(OUTPUT_TEX)/fxl.inc $(OUTPUT_TEX)/fxb.inc $(OUTPUT_TEX)/fxlglyphname.tex $(OUTPUT_TEX)/fxbglyphname.tex

tfm: pfb $(ETXFILES) $(MTXFILES) $(XCREATEFILES) createpl catmap 

$(OUTPUT_TEX)/fxl.inc : $(OUTPUT_PFB)/fxlr.afm
	@echo "### creating fxl.inc file..."
	@java -cp $(CLASSPATH) org.extex.util.font.afm.Afm2Enc -o $(OUTPUT_TEX) -n fxl -e $(SOURCE_FONTINST)/fxlenc.txt $(OUTPUT_PFB)/fxlr.afm

$(OUTPUT_TEX)/fxb.inc : $(OUTPUT_PFB)/fxbr.afm
	@echo "### creating fxb.inc file..."
	@java -cp $(CLASSPATH) org.extex.util.font.afm.Afm2Enc -o $(OUTPUT_TEX) -n fxb -e $(SOURCE_FONTINST)/fxbenc.txt $(OUTPUT_PFB)/fxbr.afm

# create the fontinst files for ...
$(OUTPUT_TEX)/create_%.create : $(SOURCE_FONTINST)/create_%.tex $(MTXFILES) $(MTXSRCFILES)
	@echo "### create fontinst file: " $<
	tex -output-directory=$(OUTPUT_TEX) $<
	@touch $@

# convert the afm files to the base mtx file
$(OUTPUT_TEX)/fxl%-8r.mtx : $(OUTPUT_PFB)/fxl%.afm $(ENCFILES)
	@echo "### converting afm to mtx: " $<
	@java -cp $(CLASSPATH) org.extex.util.font.afm.Afm2Mtx -o $(OUTPUT_TEX) --raw -e $(SOURCE_FONTINST)/fxlmtx.txt $<
	$(SOURCE_SCRIPT)/mtx2pl.sh $(SOURCE_FONTINST)/fxlmtx.txt $(OUTPUT_PFB) $(OUTPUT_TEX)

$(OUTPUT_TEX)/fxb%-8r.mtx : $(OUTPUT_PFB)/fxb%.afm $(ENCFILES)
	@echo "### converting afm to mtx: " $<
	@java -cp $(CLASSPATH) org.extex.util.font.afm.Afm2Mtx -o $(OUTPUT_TEX) --raw -e $(SOURCE_FONTINST)/fxbmtx.txt $<
	$(SOURCE_SCRIPT)/mtx2pl.sh $(SOURCE_FONTINST)/fxbmtx.txt $(OUTPUT_PFB) $(OUTPUT_TEX)

# convert the enc vector to a etx file
$(OUTPUT_TEX)/%.etx : $(OUTPUT_ENC)/%.enc
	@echo "### convert enc to etx: " $<
	@tex -output-directory=$(OUTPUT_TEX) "\input finstmsc.sty \enctoetx{`basename $< .enc`}{`basename $< .enc`}\bye"

# create the enc-vector for the unicode range block
$(OUTPUT_ENC)/xb-00.enc : $(SOURCE_SFD)/LinBiolinum.nam
	@echo "### creating xb encoding vector..." 
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 00 xb00Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-00.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 01 xb01Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-01.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 02 xb02Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-02.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 03 xb03Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-03.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 04 xb04Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-04.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 05 xb05Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-05.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 06 xb06Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-06.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 07 xb07Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-07.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 09 xb09Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-09.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 1E xb1EEncoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-1e.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 1F xb1FEncoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-1f.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 20 xb20Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-20.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 21 xb21Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-21.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 22 xb22Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-22.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 23 xb23Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-23.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 24 xb24Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-24.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 25 xb25Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-25.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 26 xb26Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-26.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 27 xb27Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-27.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 2C xb2CEncoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-2c.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector A7 xbA7Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-a7.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector E0 xbE0Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-e0.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector E1 xbE1Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-e1.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector F6 xbF6Encoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-f6.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector FB xbFBEncoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-fb.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector FF xbFFEncoding $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_ENC)/xb-ff.enc

# create the enc-vector for the unicode range block
$(OUTPUT_ENC)/xl-00.enc : $(SOURCE_SFD)/LinLibertine.nam
	@echo "### creating xl encoding vector..." 
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 00 xl00Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-00.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 01 xl01Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-01.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 02 xl02Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-02.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 03 xl03Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-03.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 04 xl04Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-04.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 05 xl05Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-05.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 06 xl06Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-06.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 07 xl07Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-07.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 09 xl09Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-09.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 1E xl1EEncoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-1e.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 1F xl1FEncoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-1f.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 20 xl20Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-20.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 21 xl21Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-21.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 22 xl22Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-22.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 23 xl23Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-23.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 24 xl24Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-24.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 25 xl25Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-25.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 26 xl26Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-26.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 27 xl27Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-27.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 2C xl2CEncoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-2c.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector A7 xlA7Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-a7.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector E0 xlE0Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-e0.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector E1 xlE1Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-e1.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector F6 xlF6Encoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-f6.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector FB xlFBEncoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-fb.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector FF xlFFEncoding $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_ENC)/xl-ff.enc

$(OUTPUT_PFB)/%.pfb : $(OUTPUT_SFD)/%.sfd
	@echo "### creating pfb font..." $@ ;
	@nice fontforge -script $(SOURCE_FFSCRIPT)/sfdtopfb.pe $< $(OUTPUT_PFB)/$(notdir $@) ;

$(OUTPUT_TEX)/test%.pdf : $(SOURCE_XELATEX)/test%.tex xelibertine.sty
	@echo "### createing test file: " $< 
	@xelatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<

$(OUTPUT_TEX)/latest%.pdf : $(SOURCE_LATEX)/latest%.tex libertine.sty
	@echo "### createing test file: " $< 
	@pdflatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<

$(OUTPUT_TEX)/%.pdf : $(SOURCE_DOKU)/xelibertine%.tex xelibertine.sty $(OUTPUT_TEX)/LinLibertineAlias.tex $(OUTPUT_TEX)/fxlglyphname.tex
		xelatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<
		-test -f $(OUTPUT_TEX)/$(patsubst %.tex,%,$<).idx && bin/splitindex.pl $(OUTPUT_TEX)/$(patsubst %.tex,%,$<) -- -g -s $(SOURCE_TEX)/index.ist && xelatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<		

$(OUTPUT_TEX)/LinLibertineAlias.tex : $(SOURCE_SFD)/LinLibertine.nam
	@echo "### creating alias file..."
	@sh $(SOURCE_SCRIPT)/nam2alias $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_TEX)/LinLibertineAlias.tex

$(OUTPUT_JAVA)/%.class : $(SOURCE_JAVA)/%.java
	@echo "### compiling java file " $<;
	@javac -cp $(CLASSPATH) -d $(OUTPUT_JAVA) $<

$(OUTPUT_TEX)/fxlglyphname.tex : $(SOURCE_SFD)/LinLibertine.nam
	@grep "^C " $(OUTPUT_PFB)/fxlr.afm | sed -e 's/\(.*\) N \(.*\) ; \(.*\)/\2/g' | sed -e 's/\([:alnum]*\) .*/\1/g' | sort > $(OUTPUT_TEX)/fxlglyphname.txt
	@cat $(OUTPUT_TEX)/fxlglyphname.txt | sed -e 's/\(^.*\)/\\GYLPHNAME{\1}/g' > $(OUTPUT_TEX)/fxlglyphname.tex
	@java -cp $(CLASSPATH) GroupGlyphs $(OUTPUT_TEX)/fxlglyphname.txt $(SOURCE_SFD)/LinLibertine.nam $(OUTPUT_TEX)/fxlgroupglyphs.tex

$(OUTPUT_TEX)/fxbglyphname.tex : $(SOURCE_SFD)/LinBiolinum.nam
	@grep "^C " $(OUTPUT_PFB)/fxbr.afm | sed -e 's/\(.*\) N \(.*\) ; \(.*\)/\2/g' | sed -e 's/\([:alnum]*\) .*/\1/g' | sort > $(OUTPUT_TEX)/fxbglyphname.txt
	@cat $(OUTPUT_TEX)/fxbglyphname.txt | sed -e 's/\(^.*\)/\\GYLPHNAME{\1}/g' > $(OUTPUT_TEX)/fxbglyphname.tex
	@java -cp $(CLASSPATH) GroupGlyphs $(OUTPUT_TEX)/fxbglyphname.txt $(SOURCE_SFD)/LinBiolinum.nam $(OUTPUT_TEX)/fxbgroupglyphs.tex

createpl:
	@echo "### create pl files..."
	cd $(OUTPUT_TEX); for f in *.pl; do echo $$f; pltotf $$f; done
	cd $(OUTPUT_TEX); for f in *.vpl; do echo $$f; vptovf $$f; done
	echo "%" > $(OUTPUT_TEX)/loadFD.tex
	cd $(OUTPUT_TEX); for f in *.fd; do echo -E "\\printFDFont{`basename $$f .fd`}" >>loadFD.tex ; done
	pdflatex -output-directory=$(OUTPUT_TEX) $(SOURCE_FONTINST)/collectFont

catmap:
	@echo "### create libertine.map file..."
	@cat $(OUTPUT_TEX)/libertine_*.map >$(OUTPUT_TEX)/tmp.map
	@cat $(OUTPUT_TEX)/biolinum_*.map >>$(OUTPUT_TEX)/tmp.map
	@cat $(OUTPUT_TEX)/tmp.map | sort | uniq > $(OUTPUT_TEX)/libertine.map

dokuinit: init version $(OUTPUT_TEX)/fxl.inc  $(OUTPUT_TEX)/fxb.inc
	-@sed -e "s/.*{\(.*\)}{\(.*\)}{\(.*\)}{\(.*\)}/\3/g" $(OUTPUT_TEX)/fxl.inc | sort > $(OUTPUT_TEX)/xlglyphlist.txt
	-@sed -e "s/\(.*\)/\\\\glyphTabEntry{fxl}{\1}/g" $(OUTPUT_TEX)/xlglyphlist.txt  > $(OUTPUT_TEX)/xlglyphlist.tex
	-@sed -e "s/.*{\(.*\)}{\(.*\)}{\(.*\)}{\(.*\)}/\3/g" $(OUTPUT_TEX)/fxb.inc | sort > $(OUTPUT_TEX)/xbglyphlist.txt
	-@sed -e "s/\(.*\)/\\\\glyphTabEntry{fxb}{\1}/g" $(OUTPUT_TEX)/xbglyphlist.txt  > $(OUTPUT_TEX)/xbglyphlist.tex

doku: dokuinit doku1 doku2 doku3

doku1: dokuinit
	pdflatex -output-directory=$(OUTPUT_TEX) $(SOURCE_DOKU)/libertinedoku.tex

inittarget:
	@echo "### creating target..."
	@mkdir -p $(TARGET)
	@mkdir -p $(OUTPUT_TEX)
	@mkdir -p $(OUTPUT_SFD)
	@mkdir -p $(OUTPUT_TTF)
	@mkdir -p $(OUTPUT_OTF)
	@mkdir -p $(OUTPUT_PFB)
	@mkdir -p $(OUTPUT_JAVA)
	@mkdir -p $(OUTPUT_ENC)

init: inittarget $(CLASSFILES)
	@echo "### copy enc and font files..."  
	@cp -u $(SOURCE_ENC)/*.enc $(OUTPUT_ENC)/
	@sh $(SOURCE_SCRIPT)/fontName2LaTeX $(SOURCE_SFD) $(OUTPUT_SFD) sfd
	@sh $(SOURCE_SCRIPT)/fontName2LaTeX $(SOURCE_OTF) $(OUTPUT_OTF) otf
	@sh $(SOURCE_SCRIPT)/fontName2LaTeX $(SOURCE_TTF) $(OUTPUT_TTF) ttf
	@sed 's/0x\(.*\) \(.*\)/\\alias{uni\1}{\2}/g' $(SOURCE_SFD)/LinLibertine.nam > $(OUTPUT_TEX)/LinLibertineName.mtx
	@sed 's/0x\(.*\) \(.*\)/\\alias{uni\1}{\2}/g' $(SOURCE_SFD)/LinBiolinum.nam > $(OUTPUT_TEX)/LinBiolinumName.mtx
	

version:
	@echo "### creating version file ...";
	@rm -f $(OUTPUT_TEX)/version
	@touch $(OUTPUT_TEX)/version
	@find $(SOURCE_OTF)/ -name '*.otf' -exec basename {} .otf >>$(OUTPUT_TEX)/version \;
	@cat $(OUTPUT_TEX)/version | sort >$(OUTPUT_TEX)/versiontmp
	@mv $(OUTPUT_TEX)/versiontmp $(OUTPUT_TEX)/version

copysf: all
	@echo "### copy to sf ...";
	scp xelibertine.sty mgn,linuxlibertine@web.sourceforge.net:htdocs/latex/
	scp $(OUTPUT_TEX)/xelibertineDoku.pdf mgn,linuxlibertine@web.sourceforge.net:htdocs/latex/

createCTAN:
	@echo "### creating zip file for CTAN ...";
	zip /tmp/xelibertine_CTAN.zip  xelibertine.sty 
	cd target/tex; zip /tmp/xelibertine_CTAN.zip  xelibertineDoku.pdf


copyfont:
	@echo "### copy font to ~/.fonts ...";
	@rm -rf ~/.fonts/LinLibertine* ~/.fonts/Biolinum* ~/.fonts/fx*
	@cp -v $(OUTPUT_OTF)/fx*.otf ~/.fonts/
	@cp -v $(OUTPUT_TTF)/fx*.ttf ~/.fonts/

help:
	@grep -v "^#" Makefile.help

readme:
	@less Readme


cleantmp:
	@echo "### removing tmp files ...";
	-@find . -name '*~' -type f -exec rm -f {} \;
	-@find . -name '*.backup' -type f -exec rm -f {} \;
	-@rm -f *.flc *.fls

clean: cleantmp
	@echo "### cleaning..."
	-@rm -rf $(TARGET)

createdist: version
	@echo "### create distribution..."  
	@rm -rf $(OUTPUT_DIST)
	@mkdir -p $(OUTPUT_DIST)
	@mkdir -p $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/fonts/map/dvips/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/fonts/enc/dvips/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/fonts/afm/public/$(FONT)
	@@mkdir -p $(OUTPUT_DIST)/texmf/fonts/tfm/public/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/fonts/type1/public/$(FONT)
	@@mkdir -p $(OUTPUT_DIST)/texmf/fonts/ttf/public/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/fonts/otf/public/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/fonts/vf/public/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/dvips/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)
	# @mkdir -p $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/babel
	@cp $(OUTPUT_PFB)/*.afm $(OUTPUT_DIST)/texmf/fonts/afm/public/$(FONT)
	@cp $(OUTPUT_TEX)/*.tfm $(OUTPUT_DIST)/texmf/fonts/tfm/public/$(FONT)
	@cp $(OUTPUT_TEX)/*.vf  $(OUTPUT_DIST)/texmf/fonts/vf/public/$(FONT)
	@cp $(OUTPUT_PFB)/*.pfb $(OUTPUT_DIST)/texmf/fonts/type1/public/$(FONT)
	@cp $(OUTPUT_TTF)/*.ttf $(OUTPUT_DIST)/texmf/fonts/ttf/public/$(FONT)
	@cp $(OUTPUT_OTF)/*.otf $(OUTPUT_DIST)/texmf/fonts/otf/public/$(FONT)
	@cp $(OUTPUT_TEX)/libertine.map $(OUTPUT_DIST)/texmf/fonts/map/dvips/$(FONT)
	@cp libertine.sty $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/
	@cp $(OUTPUT_TEX)/*.fd $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/
	@cp $(OUTPUT_TEX)/fx*.inc $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/
	#@cp $(SOURCE_TEX)/babel/*.tex $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/babel
	#@cp $(SOURCE_TEX)/babel/*.ldf $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/babel
	#@cp $(SOURCE_TEX)/babel/*.def $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/babel
	#@cp $(SOURCE_TEX)/babel/README $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/babel
	@cp $(OUTPUT_ENC)/*.enc $(OUTPUT_DIST)/texmf/fonts/enc/dvips/$(FONT)
	@rm -f $(OUTPUT_DIST)/texmf/fonts/enc/dvips/$(FONT)/8r.enc
	-@cp $(OUTPUT_TEX)/libertinedoku.pdf $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	@cp $(OUTPUT_TEX)/version $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	@cp GPL.txt $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	@cp LICENCE.txt $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	@cp OFL.txt $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	@cp Readme $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	@echo "p +libertine.map" > $(OUTPUT_DIST)/texmf/dvips/$(FONT)/config.$(FONT)
	@rm -f $(OUTPUT)/$(FONT)_latex*.zip
	@find $(OUTPUT_DIST) -type d -exec chmod 775 {} \;
	@find $(OUTPUT_DIST) -type f -exec chmod 664 {} \;
	@cd $(OUTPUT_DIST)/texmf; zip -r ../../$(FONT)_latex_`date +%Y_%m_%d`.zip *

installtl2008: createdist
	@echo "### copy to $(TL2008)"
	@rm -rf $(TL2008)/doc/fonts/libertine/*
	@rm -rf $(TL2008)/tex/latex/libertine/*
	@rm -rf $(TL2008)/dvips/libertine/*
	@rm -rf $(TL2008)/fonts/vf/public/libertine/*
	@rm -rf $(TL2008)/fonts/afm/public/libertine/*
	@rm -rf $(TL2008)/fonts/enc/public/libertine/*
	@rm -rf $(TL2008)/fonts/tfm/public/libertine/*
	@rm -rf $(TL2008)/fonts/type1/public/libertine/*
	@rm -rf $(TL2008)/fonts/map/dvips/libertine/*
	@cp -R $(OUTPUT_DIST)/texmf/* $(TL2008)/texmf-dist
	@mktexlsr
	@updmap-sys --enable Map /usr/local/texlive/2008/texmf-dist/fonts/map/dvips/libertine/libertine.map
	
	