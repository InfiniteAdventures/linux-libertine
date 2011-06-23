#   $Id$
#
TOPDIR:=$(shell pwd)

TARGET=$(TOPDIR)/target
SOURCE_SFDORG=org
SOURCE_SFDSVN=sfd
SOURCE_FFSCRIPT=script
SOURCE_DOK=dok

OUTPUT_SFD=$(TARGET)/sfd
OUTPUT_SFD_SL=$(TARGET)/sfd/sl
OUTPUT_SFD_SC=$(TARGET)/sfd/sc
OUTPUT_SFD_OT=$(TARGET)/sfd/ot
OUTPUT_SFD_WF=$(TARGET)/sfd/wf
OUTPUT_SFD_SH=$(TARGET)/sfd/sh
OUTPUT_TTF=$(TARGET)/ttf
OUTPUT_OTF=$(TARGET)/otf
OUTPUT_TAR=$(TARGET)/tar

FONTVERSION=NOTDEF
-include $(TARGET)/fontversion.mk

SFDFILES=$(wildcard $(SOURCE_SFDORG)/*.sfd)
SFDOUTFILES=$(patsubst $(SOURCE_SFDORG)/%, $(OUTPUT_SFD)/%,  $(SFDFILES))
SFDSVNFILES=$(wildcard $(SOURCE_SFDSVN)/*.sfd)

TARGETSFDFILES=$(wildcard $(OUTPUT_SFD)/*.sfd)
TARGETSFDFILESSL=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_SFD_SL)/%,  $(TARGETSFDFILES))
TARGETSFDFILESSC=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_SFD_SC)/%,  $(TARGETSFDFILES))
TARGETSFDFILESOT=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_SFD_OT)/%,  $(TARGETSFDFILES))
TARGETSFDFILESSH=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_SFD_SH)/%,  $(TARGETSFDFILES))
TARGETSFDFILESWF=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_SFD_WF)/%,  $(TARGETSFDFILES))

TTFFILES=$(patsubst $(SOURCE_SFDSVN)/%, $(OUTPUT_TTF)/%,  $(patsubst %.sfd, %.ttf ,$(SFDSVNFILES)))
OTFFILES=$(patsubst $(SOURCE_SFDSVN)/%, $(OUTPUT_OTF)/%,  $(patsubst %.sfd, %.otf ,$(SFDSVNFILES)))


all: help

help:
	@echo -e "\n\n"
	@echo -e "copyfromorg"
	@echo -e "-----------"
	@echo -e "erstellt aus allen Fonts im org-Verzeichnis entsprechende SFD-Fonts mit Versionsnummer etc."
	@echo -e "\ncreateautofonts"
	@echo -e "---------------"
	@echo -e "erstellt aus allen Fonts im sfd-Verzeichnis generierte Fonts"
	@echo -e "\ncreatetar"
	@echo -e "---------------"
	@echo -e "erstellt tar-Pakete"
	@echo -e "\n"


createautofonts: init 
	@make --no-print-directory copyfromsfd 
	@make --no-print-directory createslanted createcapitals createoutline createshadow 
	@make --no-print-directory copysvn


$(OUTPUT_SFD)/%.sfd : $(SOURCE_SFDORG)/%.sfd
	@$(SOURCE_FFSCRIPT)/copysfd.py $< $(OUTPUT_SFD)

$(OUTPUT_SFD_SL)/%.sfd : $(OUTPUT_SFD)/%.sfd
	@$(SOURCE_FFSCRIPT)/createslanted.py $< $(OUTPUT_SFD_SL)

$(OUTPUT_SFD_SC)/%.sfd : $(OUTPUT_SFD)/%.sfd
	@$(SOURCE_FFSCRIPT)/createsmallcaps.py $< $(OUTPUT_SFD_SC)

$(OUTPUT_SFD_OT)/%.sfd : $(OUTPUT_SFD)/%.sfd
	@$(SOURCE_FFSCRIPT)/createoutline.py $< $(OUTPUT_SFD_OT)

$(OUTPUT_SFD_WF)/%.sfd : $(OUTPUT_SFD)/%.sfd
	@$(SOURCE_FFSCRIPT)/createwireframe.py $< $(OUTPUT_SFD_WF)

$(OUTPUT_SFD_SH)/%.sfd : $(OUTPUT_SFD)/%.sfd
	@$(SOURCE_FFSCRIPT)/createshadow.py $< $(OUTPUT_SFD_SH)

copyfromorg: clean init $(SFDOUTFILES)
	@echo "kopiere SFD-Dateien nach sfd"
	@cp -uv $(OUTPUT_SFD)/*.sfd $(SOURCE_SFDSVN)

createslanted: init $(TARGETSFDFILESSL)

createcapitals: init $(TARGETSFDFILESSC)

createoutline: init $(TARGETSFDFILESOT)

createwireframe: init $(TARGETSFDFILESWF)

createshadow: init $(TARGETSFDFILESSH)

otf: init $(OTFFILES)

ttf: init $(TTFFILES)

copysvn:
	@# cp -u $(OUTPUT_SFD)/*.sfd $(SOURCE_SFDSVN)
	@cp -uv $(OUTPUT_SFD_SL)/*.sfd $(SOURCE_SFDSVN)
	@cp -uv $(OUTPUT_SFD_SC)/*.sfd $(SOURCE_SFDSVN)
	@cp -uv $(OUTPUT_SFD_OT)/*.sfd $(SOURCE_SFDSVN)
	@cp -uv $(OUTPUT_SFD_SH)/*.sfd $(SOURCE_SFDSVN)

copyfromsfd: init
	@echo "### copy from sfd to target"
	@cp -uv $(SOURCE_SFDSVN)/LinBiolinum_[^a]*.sfd $(OUTPUT_SFD)
	@cp -uv $(SOURCE_SFDSVN)/LinLibertine_[^a]*.sfd $(OUTPUT_SFD)

copyhome: 
	@rm -f ~/.fonts/Lin*.ttf ~/.fonts/Lin*.otf 
	@cp -u $(OUTPUT_TTF)/*.ttf ~/.fonts/
	@cp -u $(OUTPUT_OTF)/*.otf ~/.fonts/

createtar: fontversion ttf otf
	@echo "### creating tar files..."
	@mkdir -p $(OUTPUT_TAR)/sfd
	@mkdir -p $(OUTPUT_TAR)/ttf
	@mkdir -p $(OUTPUT_TAR)/otf
	@mkdir -p $(OUTPUT_TAR)/svg
	@mkdir -p $(OUTPUT_TAR)/woff
	@rm -f $(TARGET)/LinLibertine*.tgz
	@cp $(SOURCE_DOK)/* $(OUTPUT_TAR)/sfd
	@cp $(SOURCE_DOK)/* $(OUTPUT_TAR)/ttf
	@cp $(SOURCE_DOK)/* $(OUTPUT_TAR)/otf
	@cp $(SOURCE_DOK)/* $(OUTPUT_TAR)/svg
	@cp $(SOURCE_DOK)/* $(OUTPUT_TAR)/woff
	@cp $(SOURCE_SFDSVN)/*.sfd $(OUTPUT_TAR)/sfd
	@cp $(OUTPUT_TTF)/*.ttf $(OUTPUT_TAR)/ttf
	@cp $(OUTPUT_OTF)/*.otf $(OUTPUT_TAR)/otf
	@cp $(OUTPUT_TTF)/*.woff $(OUTPUT_TAR)/woff
	@cp $(OUTPUT_OTF)/*.svg $(OUTPUT_TAR)/svg
	@echo "### creating LinLibertineSRC files..."
	@cd $(OUTPUT_TAR)/sfd ; tar cfz $(TARGET)/LinLibertineSRC_$(FONTVERSION)_`date +%Y_%m_%d`.tgz *
	@echo "### creating LinLibertineTTF files..."
	@cd $(OUTPUT_TAR)/ttf ; tar cfz $(TARGET)/LinLibertineTTF_$(FONTVERSION)_`date +%Y_%m_%d`.tgz *
	@echo "### creating LinLibertineOTF files..."
	@cd $(OUTPUT_TAR)/otf ; tar cfz $(TARGET)/LinLibertineOTF_$(FONTVERSION)_`date +%Y_%m_%d`.tgz *
	@echo "### creating LinLibertineSVG files..."
	@cd $(OUTPUT_TAR)/svg ; tar cfz $(TARGET)/LinLibertineSVG_$(FONTVERSION)_`date +%Y_%m_%d`.tgz *
	@echo "### creating LinLibertineWOFF files..."
	@cd $(OUTPUT_TAR)/woff ; tar cfz $(TARGET)/LinLibertineWOFF_$(FONTVERSION)_`date +%Y_%m_%d`.tgz *


$(OUTPUT_OTF)/%.otf : $(SOURCE_SFDSVN)/%.sfd
	@echo "### creating otf/svg ..."
	@nice $(SOURCE_FFSCRIPT)/sfd2otf.py $< $(OUTPUT_OTF)

$(OUTPUT_TTF)/%.ttf : $(SOURCE_SFDSVN)/%.sfd
	@echo "### creating ttf/woff ..."
	@nice $(SOURCE_FFSCRIPT)/sfd2ttf.py $< $(OUTPUT_TTF)

fontversion: init
	@echo "### fontversion"
	@$(SOURCE_FFSCRIPT)/fontversion.py sfd/LinLibertine_R.sfd $(TARGET)

init:
	@echo "### creating target..."
	@mkdir -p $(TARGET)
	@mkdir -p $(OUTPUT_SFD)
	@mkdir -p $(OUTPUT_SFD_SL)
	@mkdir -p $(OUTPUT_SFD_SC)
	@mkdir -p $(OUTPUT_TTF)
	@mkdir -p $(OUTPUT_OTF)
	@mkdir -p $(OUTPUT_TAR)
	@mkdir -p $(OUTPUT_SFD_OT)
	@mkdir -p $(OUTPUT_SFD_WF)
	@mkdir -p $(OUTPUT_SFD_SH)

printtexname:
	@$(SOURCE_FFSCRIPT)/printtexname.py sfd

cleantmp:
	@echo "### removing tmp files ...";
	-@find . -name '*~' -type f -exec rm -f {} \;
	-@find . -name '*.backup' -type f -exec rm -f {} \;
	-@rm -f *.flc *.fls

clean: cleantmp
	@echo "### cleaning..."
	-@rm -rf $(TARGET)

