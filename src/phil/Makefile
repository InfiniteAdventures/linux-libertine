#   $Id$
#
TOPDIR:=$(shell pwd)

TARGET=$(TOPDIR)/target
SOURCE_SFDORG=org
SOURCE_FFSCRIPT=script
SOURCE_DOK=dok

OUTPUT_SFD=$(TARGET)/sfd
OUTPUT_TTF=$(TARGET)/ttf
OUTPUT_OTF=$(TARGET)/otf
OUTPUT_PFB=$(TARGET)/pfb
OUTPUT_TAR=$(TARGET)/tar

SFDFILES=$(wildcard $(SOURCE_SFDORG)/*.sfd)
SFDOUTFILES=$(patsubst $(SOURCE_SFDORG)/%, $(OUTPUT_SFD)/%,  $(SFDFILES))

TARGETSFDFILES=$(wildcard $(OUTPUT_SFD)/*.sfd)

TTFFILES=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_TTF)/%,  $(patsubst %.sfd, %.ttf ,$(TARGETSFDFILES)))
OTFFILES=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_OTF)/%,  $(patsubst %.sfd, %.otf ,$(TARGETSFDFILES)))
PFBFILES=$(patsubst $(OUTPUT_SFD)/%, $(OUTPUT_PFB)/%,  $(patsubst %.sfd, %.pfb ,$(TARGETSFDFILES)))


all: init 

$(OUTPUT_SFD)/%.sfd : $(SOURCE_SFDORG)/%.sfd
	fontforge -script $(SOURCE_FFSCRIPT)/copysfd.pe $< $(OUTPUT_SFD) \
			`basename $< | sed -e 's/\(.*\)_\(.*\)-\([0-9\.]*\).sfd/\3/g'` 

copysfd: init $(SFDOUTFILES)

otf: init $(OTFFILES) 

ttf: init $(TTFFILES) 

pfb: init $(PFBFILES) 

createtar: ttf otf
	@echo "### creating tar files..."
	@mkdir -p $(OUTPUT_TAR)/sfd
	@mkdir -p $(OUTPUT_TAR)/ttf
	@mkdir -p $(OUTPUT_TAR)/otf
	@rm -f $(TARGET)/LinLibertine*.tgz
	@cp $(SOURCE_DOK)/* $(OUTPUT_TAR)/sfd
	@cp $(SOURCE_DOK)/* $(OUTPUT_TAR)/ttf
	@cp $(SOURCE_DOK)/* $(OUTPUT_TAR)/otf
	@cp $(OUTPUT_SFD)/*.sfd $(OUTPUT_TAR)/sfd
	@cp $(OUTPUT_TTF)/*.ttf $(OUTPUT_TAR)/ttf
	@cp $(OUTPUT_OTF)/*.otf $(OUTPUT_TAR)/otf
	@echo "### creating LinLibertineSRC files..."
	@cd $(OUTPUT_TAR)/sfd ; tar cfz $(TARGET)/LinLibertineSRC_`date +%Y_%m_%d`.tgz *
	@echo "### creating LinLibertineTTF files..."
	@cd $(OUTPUT_TAR)/ttf ; tar cfz $(TARGET)/LinLibertineTTF_`date +%Y_%m_%d`.tgz *
	@echo "### creating LinLibertineOTF files..."
	@cd $(OUTPUT_TAR)/otf ; tar cfz $(TARGET)/LinLibertineOTF_`date +%Y_%m_%d`.tgz *


$(OUTPUT_OTF)/%.otf : $(OUTPUT_SFD)/%.sfd
	@echo "### creating otf font..." $@ ;
	@nice fontforge -script $(SOURCE_FFSCRIPT)/sfdtootf.pe $< $(OUTPUT_OTF)/$(notdir $@) ;

$(OUTPUT_TTF)/%.ttf : $(OUTPUT_SFD)/%.sfd
	@echo "### creating ttf font..." $@ ;
	@nice fontforge -script $(SOURCE_FFSCRIPT)/sfdtottf.pe $< $(OUTPUT_TTF)/$(notdir $@) ;

$(OUTPUT_PFB)/%.pfb : $(OUTPUT_SFD)/%.sfd
	@echo "### creating pfb font..." $@ ;
	@nice fontforge -script $(SOURCE_FFSCRIPT)/sfdtopfb.pe $< $(OUTPUT_PFB)/$(notdir $@) ;


init:
	@echo "### creating target..."
	@mkdir -p $(TARGET)
	@mkdir -p $(OUTPUT_SFD)
	@mkdir -p $(OUTPUT_TTF)
	@mkdir -p $(OUTPUT_OTF)
	@mkdir -p $(OUTPUT_PFB)
	@mkdir -p $(OUTPUT_TAR)


cleantmp:
	@echo "### removing tmp files ...";
	-@find . -name '*~' -type f -exec rm -f {} \;
	-@find . -name '*.backup' -type f -exec rm -f {} \;
	-@rm -f *.flc *.fls

clean: cleantmp
	@echo "### cleaning..."
	-@rm -rf $(TARGET)

	