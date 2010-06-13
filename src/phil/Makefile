#   $Id$
#
TOPDIR:=$(shell pwd)

TARGET=$(TOPDIR)/target
SOURCE_SFDORG=org
SOURCE_SFDSVN=sfd
SOURCE_FFSCRIPT=script
SOURCE_DOK=dok

OUTPUT_SFD=$(SOURCE_SFDSVN)
OUTPUT_SFD_SL=$(TARGET)/sfd/sl
OUTPUT_SFD_SC=$(TARGET)/sfd/sc
OUTPUT_SFD_OT=$(TARGET)/sfd/ot
OUTPUT_SFD_SH=$(TARGET)/sfd/sh
OUTPUT_TTF=$(TARGET)/ttf
OUTPUT_OTF=$(TARGET)/otf
OUTPUT_TAR=$(TARGET)/tar

SFDFILES=$(wildcard $(SOURCE_SFDORG)/*.sfd)
SFDOUTFILES=$(patsubst $(SOURCE_SFDORG)/%, $(OUTPUT_SFD)/%,  $(SFDFILES))
SFDSVNFILES=$(wildcard $(SOURCE_SFDSVN)/*.sfd)

TARGETSFDFILES=$(wildcard $(OUTPUT_SFD)/*.sfd)
TARGETSFDFILESSL=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_SFD_SL)/%,  $(TARGETSFDFILES))
TARGETSFDFILESSC=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_SFD_SC)/%,  $(TARGETSFDFILES))
TARGETSFDFILESOT=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_SFD_OT)/%,  $(TARGETSFDFILES))
TARGETSFDFILESSH=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_SFD_SH)/%,  $(TARGETSFDFILES))

TTFFILES=$(patsubst $(SOURCE_SFDSVN)/%, $(OUTPUT_TTF)/%,  $(patsubst %.sfd, %.ttf ,$(SFDSVNFILES)))
OTFFILES=$(patsubst $(SOURCE_SFDSVN)/%, $(OUTPUT_OTF)/%,  $(patsubst %.sfd, %.otf ,$(SFDSVNFILES)))


all: init 

$(OUTPUT_SFD)/%.sfd : $(SOURCE_SFDORG)/%.sfd
	@$(SOURCE_FFSCRIPT)/copysfd.py $< $(OUTPUT_SFD) 

$(OUTPUT_SFD_SL)/%.sfd : $(OUTPUT_SFD)/%.sfd
	@$(SOURCE_FFSCRIPT)/createslanted.py $< $(OUTPUT_SFD_SL) 

$(OUTPUT_SFD_SC)/%.sfd : $(OUTPUT_SFD)/%.sfd
	@$(SOURCE_FFSCRIPT)/createsmallcaps.py $< $(OUTPUT_SFD_SC) 

$(OUTPUT_SFD_OT)/%.sfd : $(OUTPUT_SFD)/%.sfd
	@$(SOURCE_FFSCRIPT)/createoutline.py $< $(OUTPUT_SFD_OT) 

$(OUTPUT_SFD_SH)/%.sfd : $(OUTPUT_SFD)/%.sfd
	@$(SOURCE_FFSCRIPT)/createshadow.py $< $(OUTPUT_SFD_SH) 

copysfd: init $(SFDOUTFILES)

createslanted: init $(TARGETSFDFILESSL)

createcapitals: init $(TARGETSFDFILESSC)

createoutline: init $(TARGETSFDFILESOT)

createshadow: init $(TARGETSFDFILESSH)

otf: init $(OTFFILES) 

ttf: init $(TTFFILES) 

copysvn: copysfd
	@cp -u $(OUTPUT_SFD)/*.sfd $(SOURCE_SFDSVN)
	@#cp -u $(OUTPUT_SFD)/*.nam $(SOURCE_SFDSVN)
	@cp -u $(OUTPUT_SFD_SL)/*.sfd $(SOURCE_SFDSVN)
	@cp -u $(OUTPUT_SFD_SC)/*.sfd $(SOURCE_SFDSVN)
	@cp -u $(OUTPUT_SFD_OT)/*.sfd $(SOURCE_SFDSVN)
	@cp -u $(OUTPUT_SFD_SH)/*.sfd $(SOURCE_SFDSVN)

copysfdorg: init
	@cp -u $(SOURCE_SFDSVN)/LinBiolinum_Re-*.sfd $(SOURCE_SFDORG)
	@cp -u $(SOURCE_SFDSVN)/LinBiolinum_Bd-*.sfd $(SOURCE_SFDORG)
	@cp -u $(SOURCE_SFDSVN)/LinBiolinum_It-*.sfd $(SOURCE_SFDORG)
	@cp -u $(SOURCE_SFDSVN)/LinBiolinum_Kb-*.sfd $(SOURCE_SFDORG)
	@#cp -u $(SOURCE_SFDSVN)/LinBiolinum_OT-*.sfd $(SOURCE_SFDORG)
	@#cp -u $(SOURCE_SFDSVN)/LinBiolinum_SH-*.sfd $(SOURCE_SFDORG)
	@cp -u $(SOURCE_SFDSVN)/LinLibertine_Re-*.sfd $(SOURCE_SFDORG)
	@cp -u $(SOURCE_SFDSVN)/LinLibertine_Bd-*.sfd $(SOURCE_SFDORG)
	@cp -u $(SOURCE_SFDSVN)/LinLibertine_BI-*.sfd $(SOURCE_SFDORG)
	@cp -u $(SOURCE_SFDSVN)/LinLibertine_It-*.sfd $(SOURCE_SFDORG)
	
createtar: ttf otf
	@echo "### creating tar files..."
	@mkdir -p $(OUTPUT_TAR)/sfd
	@mkdir -p $(OUTPUT_TAR)/ttf
	@mkdir -p $(OUTPUT_TAR)/otf
	@rm -f $(TARGET)/LinLibertine*.tgz
	@cp $(SOURCE_DOK)/* $(OUTPUT_TAR)/sfd
	@cp $(SOURCE_DOK)/* $(OUTPUT_TAR)/ttf
	@cp $(SOURCE_DOK)/* $(OUTPUT_TAR)/otf
	@cp $(SOURCE_SFDSVN)/*.sfd $(OUTPUT_TAR)/sfd
	@cp $(OUTPUT_TTF)/*.ttf $(OUTPUT_TAR)/ttf
	@cp $(OUTPUT_OTF)/*.otf $(OUTPUT_TAR)/otf
	@echo "### creating LinLibertineSRC files..."
	@cd $(OUTPUT_TAR)/sfd ; tar cfz $(TARGET)/LinLibertineSRC_`date +%Y_%m_%d`.tgz *
	@echo "### creating LinLibertineTTF files..."
	@cd $(OUTPUT_TAR)/ttf ; tar cfz $(TARGET)/LinLibertineTTF_`date +%Y_%m_%d`.tgz *
	@echo "### creating LinLibertineOTF files..."
	@cd $(OUTPUT_TAR)/otf ; tar cfz $(TARGET)/LinLibertineOTF_`date +%Y_%m_%d`.tgz *


$(OUTPUT_OTF)/%.otf : $(SOURCE_SFDSVN)/%.sfd
	@nice $(SOURCE_FFSCRIPT)/sfd2otf.py $< $(OUTPUT_OTF)

$(OUTPUT_TTF)/%.ttf : $(SOURCE_SFDSVN)/%.sfd
	@nice $(SOURCE_FFSCRIPT)/sfd2ttf.py $< $(OUTPUT_TTF)

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
	@mkdir -p $(OUTPUT_SFD_SH)


cleantmp:
	@echo "### removing tmp files ...";
	-@find . -name '*~' -type f -exec rm -f {} \;
	-@find . -name '*.backup' -type f -exec rm -f {} \;
	-@rm -f *.flc *.fls

clean: cleantmp
	@echo "### cleaning..."
	-@rm -rf $(TARGET)

	