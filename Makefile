#   $Id$
#
TOPDIR:=$(shell pwd)
FONT=libertine
XEFONT=libertine

TARGET=$(TOPDIR)/target
OUTPUT_TEX=$(TARGET)/tex
# PDFLATEXPARAM=-interaction=nonstopmode
# PDFLATEXPARAM=-recorder
PDFLATEXPARAM=

TEXMF_MAIN:=$(shell kpsewhich -expand-var='$$TEXMFLOCAL')
MYTEXMF_LOCAL=/usr/local/share/texmf
TEXLIVE:=/usr/local/texlive/2009
TLX:=/usr/local/share/texmf-x

SOURCE_TEX=src/tex
SOURCE_XELATEX=src/test/xelatex
SOURCE_LATEX=src/test/latex
SOURCE_FONTINST=src/fontinst
SOURCE_DOKU=src/doku
SOURCE_JAVA=src/java
SOURCE_SFD=src/phil/sfd
SOURCE_ENC=src/enc
SOURCE_SCRIPT=src/scripts
SOURCE_FFSCRIPT=src/phil/script
SOURCE_DPKG=src/dpkg
SOURCE_BSP_LATEX=src/beispiele

OUTPUT_SFD=$(TARGET)/sfd
OUTPUT_TTF=$(TARGET)/ttf
OUTPUT_OTF=$(TARGET)/otf
OUTPUT_PFB=$(TARGET)/pfb
OUTPUT_ENC=$(TARGET)/enc
OUTPUT_JAVA=$(TARGET)/classes
OUTPUT_DIST=$(TARGET)/dist
OUTPUT_DSRC=$(TARGET)/docsrc

TEXFILES=$(wildcard *.tex) $(wildcard $(SOURCE_XELATEX)/*.tex) $(wildcard $(SOURCE_LATEX)/*.tex) $(SOURCE_DOKU)/libertinedokulatex.tex $(SOURCE_DOKU)/libertinedokuxelatex.tex
PDFTEXFILES=$(patsubst %.tex, $(OUTPUT_TEX)/%.pdf ,$(notdir $(TEXFILES)))

BSP_LATEX_FILES=$(wildcard $(SOURCE_BSP_LATEX)/bsp*.tex)
PDF_BSP_LATEX_FILES=$(patsubst %.tex, $(OUTPUT_TEX)/%.pdf ,$(notdir $(BSP_LATEX_FILES)))
PDF_BSP_XELATEX_FILES=$(patsubst %.tex, $(OUTPUT_TEX)/x%.pdf ,$(notdir $(BSP_LATEX_FILES)))

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

TEXINPUTS:=.:$(OUTPUT_TEX):$(SOURCE_FONTINST):$(SOURCE_TEX):$(SOURCE_XELATEX):$(OUTPUT_ENC):$(OUTPUT_PFB):$(SOURCE_TEX)/babel:$(SOURCE_DOKU):$(SOURCE_BSP_LATEX):$(TEXINPUTS)
CLASSPATH:=$(TARGET)/classes:lib/fontwareone.jar:$(CLASSPATH)


all: init $(CLASSFILES) $(PDFTEXFILES) doku

pfb: init $(PFBFILES) $(OUTPUT_ENC)/xl-00.enc $(OUTPUT_ENC)/xb-00.enc $(OUTPUT_TEX)/fxl.inc $(OUTPUT_TEX)/fxb.inc $(OUTPUT_TEX)/fxlglyphname.tex $(OUTPUT_TEX)/fxbglyphname.tex

otf: init $(OTFFILES) 

ttf: init $(TTFFILES) 

tfm: pfb $(ETXFILES) $(MTXFILES) $(XCREATEFILES) createpl catmap dokuinit 

bsp: $(PDF_BSP_LATEX_FILES) $(PDF_BSP_XELATEX_FILES)
	pdflatex -output-directory=$(OUTPUT_TEX) $(SOURCE_BSP_LATEX)/beispiel.tex

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

#$(OUTPUT_TEX)/fxlro.mtx: $(MTXFILES)
#	set -e
#	tex -output-directory=$(OUTPUT_TEX) $(SOURCE_FONTINST)/createslanted.tex

$(OUTPUT_TEX)/fxb%-8r.mtx : $(OUTPUT_PFB)/fxb%.afm $(ENCFILES)
	@echo "### converting afm to mtx: " $<
	@java -cp $(CLASSPATH) org.extex.util.font.afm.Afm2Mtx -o $(OUTPUT_TEX) --raw -e $(SOURCE_FONTINST)/fxbmtx.txt $<
	$(SOURCE_SCRIPT)/mtx2pl.sh $(SOURCE_FONTINST)/fxbmtx.txt $(OUTPUT_PFB) $(OUTPUT_TEX)

# convert the enc vector to a etx file
$(OUTPUT_TEX)/%.etx : $(OUTPUT_ENC)/%.enc
	@echo "### convert enc to etx: " $<
	@tex -output-directory=$(OUTPUT_TEX) "\input finstmsc.sty \enctoetx{`basename $< .enc`}{`basename $< .enc`}\bye"

# create the enc-vector for the unicode range block
$(OUTPUT_ENC)/xb-00.enc : $(SOURCE_SFD)/LinBiolinumO.nam
	@echo "### creating xb encoding vector..." 
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 00 xb00Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-00.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 01 xb01Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-01.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 02 xb02Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-02.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 03 xb03Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-03.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 04 xb04Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-04.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 05 xb05Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-05.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 06 xb06Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-06.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 07 xb07Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-07.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 09 xb09Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-09.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 1E xb1EEncoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-1e.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 1F xb1FEncoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-1f.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 20 xb20Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-20.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 21 xb21Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-21.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 22 xb22Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-22.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 23 xb23Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-23.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 24 xb24Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-24.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 25 xb25Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-25.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 26 xb26Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-26.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 27 xb27Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-27.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 2C xb2CEncoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-2c.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector A7 xbA7Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-a7.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector E0 xbE0Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-e0.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector E1 xbE1Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-e1.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector F6 xbF6Encoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-f6.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector FB xbFBEncoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-fb.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector FF xbFFEncoding $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_ENC)/xb-ff.enc

# create the enc-vector for the unicode range block
$(OUTPUT_ENC)/xl-00.enc : $(SOURCE_SFD)/LinLibertineO.nam
	@echo "### creating xl encoding vector..." 
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 00 xl00Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-00.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 01 xl01Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-01.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 02 xl02Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-02.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 03 xl03Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-03.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 04 xl04Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-04.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 05 xl05Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-05.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 06 xl06Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-06.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 07 xl07Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-07.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 09 xl09Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-09.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 1E xl1EEncoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-1e.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 1F xl1FEncoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-1f.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 20 xl20Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-20.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 21 xl21Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-21.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 22 xl22Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-22.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 23 xl23Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-23.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 24 xl24Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-24.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 25 xl25Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-25.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 26 xl26Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-26.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 27 xl27Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-27.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector 2C xl2CEncoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-2c.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector A7 xlA7Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-a7.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector E0 xlE0Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-e0.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector E1 xlE1Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-e1.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector F6 xlF6Encoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-f6.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector FB xlFBEncoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-fb.enc
	@java -cp $(CLASSPATH) CreateUnicodeEncodingVector FF xlFFEncoding $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_ENC)/xl-ff.enc

$(OUTPUT_PFB)/%.pfb : $(OUTPUT_SFD)/%.sfd
	@echo "### creating pfb font..." $@ ;
	@nice $(SOURCE_FFSCRIPT)/sfd2pfb.py $< $(OUTPUT_PFB) ;

$(OUTPUT_OTF)/%.otf : $(OUTPUT_SFD)/%.sfd
	@echo "### creating otf font..." $@ ;
	@nice $(SOURCE_FFSCRIPT)/sfd2otf.py $< $(OUTPUT_OTF) ;

$(OUTPUT_TTF)/%.ttf : $(OUTPUT_SFD)/%.sfd
	@echo "### creating ttf font..." $@ ;
	@nice $(SOURCE_FFSCRIPT)/sfd2ttf.py $< $(OUTPUT_TTF) ;

$(OUTPUT_TEX)/test%.pdf : $(SOURCE_XELATEX)/test%.tex texmf/tex/xelatex/libertine/libertine.sty
	@echo "### createing test file: " $< 
	@xelatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<

$(OUTPUT_TEX)/latest%.pdf : $(SOURCE_LATEX)/latest%.tex texmf/tex/latex/libertine/libertine.sty
	@echo "### createing test file: " $< 
	@pdflatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<

$(OUTPUT_TEX)/bsp%.pdf : $(SOURCE_BSP_LATEX)/bsp%.tex libertinenew.sty
	@echo "### createing bsp file: " $< 
	@pdflatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<
	@pdfcrop --clip $@ $(OUTPUT_TEX)/tmp.pdf
	@mv $(OUTPUT_TEX)/tmp.pdf $@

$(OUTPUT_TEX)/xbsp%.pdf : $(SOURCE_BSP_LATEX)/bsp%.tex libertinenew.sty
	@echo "### createing bsp file: " $< 
	@xelatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX)  -jobname=$(patsubst %.pdf,%,$(notdir $@)) $<
	@pdfcrop --clip $@ $(OUTPUT_TEX)/tmp.pdf
	@mv $(OUTPUT_TEX)/tmp.pdf $@

$(OUTPUT_TEX)/libertinedokuxelatex.pdf : $(SOURCE_DOKU)/libertinedokuxelatex.tex texmf/tex/xelatex/libertine/libertine.sty
		xelatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<
		-test -f $(OUTPUT_TEX)/$(patsubst %.tex,%,$(notdir $<)).idx && bin/splitindex.pl $(OUTPUT_TEX)/$(patsubst %.tex,%,$(notdir $<)) -- -g -s $(SOURCE_TEX)/index.ist && xelatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<		
		xelatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<

$(OUTPUT_TEX)/libertinedokulatex.pdf : $(SOURCE_DOKU)/libertinedokulatex.tex texmf/tex/latex/libertine/libertine.sty
		pdflatex -interaction=nonstopmode $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<
		pdflatex -interaction=nonstopmode $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<
		# -test -f $(OUTPUT_TEX)/$(patsubst %.tex,%,$(notdir $<)).idx && bin/splitindex.pl $(OUTPUT_TEX)/$(patsubst %.tex,%,$(notdir $<)) -- -g -s $(SOURCE_TEX)/index.ist && pdflatex $(PDFLATEXPARAM) -output-directory=$(OUTPUT_TEX) $<		

$(OUTPUT_TEX)/LinLibertineAlias.tex : $(SOURCE_SFD)/LinLibertineO.nam
	@echo "### creating alias file..."
	@sh $(SOURCE_SCRIPT)/nam2alias $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_TEX)/LinLibertineAlias.tex

$(OUTPUT_JAVA)/%.class : $(SOURCE_JAVA)/%.java
	@echo "### compiling java file " $<;
	@javac -cp $(CLASSPATH) -d $(OUTPUT_JAVA) $<

$(OUTPUT_TEX)/fxlglyphname.tex : $(SOURCE_SFD)/LinLibertineO.nam
	@grep "^C " $(OUTPUT_PFB)/fxlr.afm | sed -e 's/\(.*\) N \(.*\) ; \(.*\)/\2/g' | sed -e 's/\([:alnum]*\) .*/\1/g' | sort > $(OUTPUT_TEX)/fxlglyphname.txt
	@cat $(OUTPUT_TEX)/fxlglyphname.txt | sed -e 's/\(^.*\)/\\GYLPHNAME{\1}/g' > $(OUTPUT_TEX)/fxlglyphname.tex
	@java -cp $(CLASSPATH) GroupGlyphs $(OUTPUT_TEX)/fxlglyphname.txt $(SOURCE_SFD)/LinLibertineO.nam $(OUTPUT_TEX)/fxlgroupglyphs.tex

$(OUTPUT_TEX)/fxbglyphname.tex : $(SOURCE_SFD)/LinBiolinumO.nam
	@grep "^C " $(OUTPUT_PFB)/fxbr.afm | sed -e 's/\(.*\) N \(.*\) ; \(.*\)/\2/g' | sed -e 's/\([:alnum]*\) .*/\1/g' | sort > $(OUTPUT_TEX)/fxbglyphname.txt
	@cat $(OUTPUT_TEX)/fxbglyphname.txt | sed -e 's/\(^.*\)/\\GYLPHNAME{\1}/g' > $(OUTPUT_TEX)/fxbglyphname.tex
	@java -cp $(CLASSPATH) GroupGlyphs $(OUTPUT_TEX)/fxbglyphname.txt $(SOURCE_SFD)/LinBiolinumO.nam $(OUTPUT_TEX)/fxbgroupglyphs.tex

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

dokuinit:
	-@sed -e "s/.*{\(.*\)}{\(.*\)}{\(.*\)}{\(.*\)}/\3/g" $(OUTPUT_TEX)/fxl.inc | sort > $(OUTPUT_TEX)/xlglyphlist.txt
	-@sed -e "s/\(.*\)/\\\\glyphTabEntry{fxl}{\1}/g" $(OUTPUT_TEX)/xlglyphlist.txt  > $(OUTPUT_TEX)/xlglyphlist.tex
	-@sed -e "s/.*{\(.*\)}{\(.*\)}{\(.*\)}{\(.*\)}/\3/g" $(OUTPUT_TEX)/fxb.inc | sort > $(OUTPUT_TEX)/xbglyphlist.txt
	-@sed -e "s/\(.*\)/\\\\glyphTabEntry{fxb}{\1}/g" $(OUTPUT_TEX)/xbglyphlist.txt  > $(OUTPUT_TEX)/xbglyphlist.tex

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
	@cp -u $(SOURCE_SFD)/LinBiolinum_Re*.sfd $(OUTPUT_SFD)/fxbr.sfd
	@cp -u $(SOURCE_SFD)/LinBiolinum_It*.sfd $(OUTPUT_SFD)/fxbri.sfd
	@cp -u $(SOURCE_SFD)/LinBiolinum_Bd*.sfd $(OUTPUT_SFD)/fxbb.sfd
	@cp -u $(SOURCE_SFD)/LinBiolinum_Sl*.sfd $(OUTPUT_SFD)/fxbro.sfd
	@cp -u $(SOURCE_SFD)/LinBiolinum_BSl*.sfd $(OUTPUT_SFD)/fxbbo.sfd
	@cp -u $(SOURCE_SFD)/LinBiolinum_Kb*.sfd $(OUTPUT_SFD)/fxbkb.sfd
	@cp -u $(SOURCE_SFD)/LinLibertine_Re*.sfd $(OUTPUT_SFD)/fxlr.sfd
	@cp -u $(SOURCE_SFD)/LinLibertine_Bd*.sfd $(OUTPUT_SFD)/fxlb.sfd
	@cp -u $(SOURCE_SFD)/LinLibertine_Sl*.sfd $(OUTPUT_SFD)/fxlro.sfd
	@cp -u $(SOURCE_SFD)/LinLibertine_It*.sfd $(OUTPUT_SFD)/fxlri.sfd
	@cp -u $(SOURCE_SFD)/LinLibertine_BSl*.sfd $(OUTPUT_SFD)/fxlbo.sfd
	@cp -u $(SOURCE_SFD)/LinLibertine_BI*.sfd $(OUTPUT_SFD)/fxlbi.sfd
	@rm -f $(OUTPUT_TEX)/version $(OUTPUT_TEX)/version.tmp
	@find src/phil/sfd/ -name '*.sfd' -exec basename {} .sfd \; >> $(OUTPUT_TEX)/version.tmp
	@sort $(OUTPUT_TEX)/version.tmp | uniq > $(OUTPUT_TEX)/version
	@rm -f $(OUTPUT_TEX)/version.tmp
	@sed 's/0x\(.*\) \(.*\)/\\alias{uni\1}{\2}/g' $(SOURCE_SFD)/LinLibertineO.nam > $(OUTPUT_TEX)/LinLibertineName.mtx
	@sed 's/0x\(.*\) \(.*\)/\\alias{uni\1}{\2}/g' $(SOURCE_SFD)/LinBiolinumO.nam > $(OUTPUT_TEX)/LinBiolinumName.mtx
	

copysf: all
	@echo "### copy to sf ...";
	scp $(OUTPUT_TEX)/libertinedokuxelatex.pdf mgn,linuxlibertine@web.sourceforge.net:htdocs/latex/
	scp $(OUTPUT_TEX)/libertinedokulatex.pdf mgn,linuxlibertine@web.sourceforge.net:htdocs/latex/

copyfont:
	@echo "### copy font to ~/.fonts ...";
	@rm -rf ~/.fonts/LinLibertine* ~/.fonts/Biolinum* ~/.fonts/fx*
	@cp -v $(OUTPUT_OTF)/fx*.otf ~/.fonts/
	@cp -v $(OUTPUT_TTF)/fx*.ttf ~/.fonts/

help:
	@grep -v "^#" Makefile.help

readme:
	@less Readme.txt

cleantmp:
	@echo "### removing tmp files ...";
	-@find . -name '*~' -type f -exec rm -f {} \;
	-@find . -name '*.backup' -type f -exec rm -f {} \;
	-@rm -f *.flc *.fls

clean: cleantmp
	@echo "### cleaning..."
	-@rm -rf $(TARGET)

cleanhome:
	rm -rf ~/.texlive2009
	rm -rf ~/.texmf-var

al:
	@acroread target/tex/libertinedokulatex.pdf &
	
ax:
	@acroread target/tex/libertinedokuxelatex.pdf &

createdist: initdist cpdsrc copydist

initdist: 
	@rm -rf $(OUTPUT_DIST)
	@mkdir -p $(OUTPUT_DIST)

copydist: 
	@echo "### create distribution..."  
	@mkdir -p $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/fonts/map/dvips/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/fonts/enc/dvips/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/fonts/afm/public/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/fonts/tfm/public/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/fonts/type1/public/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/fonts/truetype/public/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/fonts/opentype/public/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/fonts/vf/public/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/dvips/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)
	@mkdir -p $(OUTPUT_DIST)/texmf/tex/xelatex/$(XEFONT)
	# @mkdir -p $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/babel
	@cp $(OUTPUT_PFB)/*.afm $(OUTPUT_DIST)/texmf/fonts/afm/public/$(FONT)
	@cp $(OUTPUT_TEX)/*.tfm $(OUTPUT_DIST)/texmf/fonts/tfm/public/$(FONT)
	@cp $(OUTPUT_TEX)/*.vf  $(OUTPUT_DIST)/texmf/fonts/vf/public/$(FONT)
	@cp $(OUTPUT_PFB)/*.pfb $(OUTPUT_DIST)/texmf/fonts/type1/public/$(FONT)
	@cp $(OUTPUT_TTF)/*.ttf $(OUTPUT_DIST)/texmf/fonts/truetype/public/$(FONT)
	@cp $(OUTPUT_OTF)/*.otf $(OUTPUT_DIST)/texmf/fonts/opentype/public/$(FONT)
	@cp $(OUTPUT_TEX)/libertine.map $(OUTPUT_DIST)/texmf/fonts/map/dvips/$(FONT)
	@cp texmf/tex/latex/libertine/libertine.sty $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/
	@cp texmf/tex/xelatex/libertine/libertine.sty $(OUTPUT_DIST)/texmf/tex/xelatex/$(XEFONT)/
	@cp $(OUTPUT_TEX)/*.fd $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/
	@cp $(OUTPUT_TEX)/fx*.inc $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/
	#@cp $(SOURCE_TEX)/babel/*.tex $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/babel
	#@cp $(SOURCE_TEX)/babel/*.ldf $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/babel
	#@cp $(SOURCE_TEX)/babel/*.def $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/babel
	#@cp $(SOURCE_TEX)/babel/README $(OUTPUT_DIST)/texmf/tex/latex/$(FONT)/babel
	@cp $(OUTPUT_ENC)/*.enc $(OUTPUT_DIST)/texmf/fonts/enc/dvips/$(FONT)
	@rm -f $(OUTPUT_DIST)/texmf/fonts/enc/dvips/$(FONT)/8r.enc
	#-@cp $(OUTPUT_TEX)/libertinedokulatex.pdf $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	#-@cp $(OUTPUT_TEX)/libertinedokuxelatex.pdf $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	@cp $(OUTPUT_TEX)/version $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	@cp GPL.txt $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	@cp LICENCE.txt $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	@cp OFL.txt $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	@cp Readme.txt $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	@echo "p +libertine.map" > $(OUTPUT_DIST)/texmf/dvips/$(FONT)/config.$(FONT)
	@rm -f $(TARGET)/$(FONT)_*.zip
	@find $(OUTPUT_DIST) -type d -exec chmod 775 {} \;
	@find $(OUTPUT_DIST) -type f -exec chmod 664 {} \;
	@cd $(OUTPUT_DIST)/texmf; zip -r ../../$(FONT)_`date +%Y_%m_%d_%H_%M`.zip *

installtllocal:
	@echo "### copy to $(TEXLIVE)/../texmf-local"
	@rm -rf $(TEXLIVE)/../texmf-local/doc/fonts/libertine/*
	@rm -rf $(TEXLIVE)/../texmf-local/tex/latex/libertine/*
	@rm -rf $(TEXLIVE)/../texmf-local/tex/xelatex/libertine/*
	@rm -rf $(TEXLIVE)/../texmf-local/dvips/libertine/*
	@rm -rf $(TEXLIVE)/../texmf-local/fonts/vf/public/libertine/*
	@rm -rf $(TEXLIVE)/../texmf-local/fonts/afm/public/libertine/*
	@rm -rf $(TEXLIVE)/../texmf-local/fonts/enc/public/libertine/*
	@rm -rf $(TEXLIVE)/../texmf-local/fonts/tfm/public/libertine/*
	@rm -rf $(TEXLIVE)/../texmf-local/fonts/type1/public/libertine/*
	@rm -rf $(TEXLIVE)/../texmf-local/fonts/map/dvips/libertine/*
	@cp -R $(OUTPUT_DIST)/texmf/* $(TEXLIVE)/../texmf-local

installtl2009: createdist installtllocal
	@echo "### copy to $(TEXLIVE)"
	@rm -rf $(TEXLIVE)/doc/fonts/libertine/*
	@rm -rf $(TEXLIVE)/tex/latex/libertine/*
	@rm -rf $(TEXLIVE)/tex/xelatex/libertine/*
	@rm -rf $(TEXLIVE)/dvips/libertine/*
	@rm -rf $(TEXLIVE)/fonts/vf/public/libertine/*
	@rm -rf $(TEXLIVE)/fonts/afm/public/libertine/*
	@rm -rf $(TEXLIVE)/fonts/enc/public/libertine/*
	@rm -rf $(TEXLIVE)/fonts/tfm/public/libertine/*
	@rm -rf $(TEXLIVE)/fonts/type1/public/libertine/*
	@rm -rf $(TEXLIVE)/fonts/map/dvips/libertine/*
	@cp -R $(OUTPUT_DIST)/texmf/* $(TEXLIVE)/texmf-dist
	@mktexlsr
	@grep libertine $(TEXLIVE)/texmf-config/web2c/updmap.cfg && updmap-sys || updmap-sys --enable Map libertine.map

xxxcopyLaTeX:
	@echo "### copy to xxx LaTeX"
	@rm -rf ~/daten/sv/LaTeX/texmf/doc/fonts/libertine/*
	@rm -rf ~/daten/sv/LaTeX/texmf/tex/latex/libertine/*
	@rm -rf ~/daten/sv/LaTeX/texmf/tex/xelatex/libertine/*
	@rm -rf ~/daten/sv/LaTeX/texmf/dvips/libertine/*
	@rm -rf ~/daten/sv/LaTeX/texmf/fonts/vf/public/libertine/*
	@rm -rf ~/daten/sv/LaTeX/texmf/fonts/afm/public/libertine/*
	@rm -rf ~/daten/sv/LaTeX/texmf/fonts/enc/public/libertine/*
	@rm -rf ~/daten/sv/LaTeX/texmf/fonts/tfm/public/libertine/*
	@rm -rf ~/daten/sv/LaTeX/texmf/fonts/type1/public/libertine/*
	@rm -rf ~/daten/sv/LaTeX/texmf/fonts/map/dvips/libertine/*
	@cp -R $(OUTPUT_DIST)/texmf/* ~/daten/sv/LaTeX/texmf
	@cp $(OUTPUT_OTF)/*.otf ~/daten/sv/LaTeX/fonts

cpdsrc: 
	@echo "### copy doku to $(OUTPUT_DSRC)"
	@rm -rf $(OUTPUT_DSRC)
	@mkdir -p $(OUTPUT_DSRC)
	@cp $(SOURCE_DOKU)/* $(OUTPUT_DSRC)
	@cp $(SOURCE_TEX)/*.cls $(OUTPUT_DSRC)
	@cp $(SOURCE_TEX)/lstsample.sty $(OUTPUT_DSRC)
	@cp $(OUTPUT_TEX)/version* $(OUTPUT_DSRC)
	@cp $(OUTPUT_TEX)/xlglyphlist.tex $(OUTPUT_DSRC)
	@cp $(OUTPUT_TEX)/xbglyphlist.tex $(OUTPUT_DSRC)
	@cp $(OUTPUT_TEX)/fxlgroupglyphs.tex $(OUTPUT_DSRC)
	@cp $(OUTPUT_TEX)/fxbgroupglyphs.tex $(OUTPUT_DSRC)
	@cp $(OUTPUT_TEX)/fxlglyphname.tex $(OUTPUT_DSRC)
	@cp $(OUTPUT_TEX)/fxbglyphname.tex $(OUTPUT_DSRC)
	@cp $(OUTPUT_TEX)/loadFD.tex $(OUTPUT_DSRC)
	@cp $(OUTPUT_TEX)/*.inc $(OUTPUT_DSRC)
	@echo "see http://linuxlibertine.sourceforge.net/latex/" >$(OUTPUT_DSRC)/readme
	@echo "pdflatex libertinedokulatex.tex" >>$(OUTPUT_DSRC)/readme
	@echo "xelatex libertinedokuxelatex.tex" >>$(OUTPUT_DSRC)/readme
	@cd $(OUTPUT_DSRC); zip -r ../docsrc.zip *
	@mkdir -p $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	@cp $(TARGET)/docsrc.zip $(OUTPUT_DIST)/texmf/doc/fonts/$(FONT)
	
	