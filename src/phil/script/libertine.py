#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Namen für den Libertine Font.
#
# $Id$
#
# Michael Niedermair m.g.n@gmx.de
#
fonts = {};
# --------------------------------------------------------------
# LIBERTINE
# Linux Libertine Regular
libertineRe = {};
libertineRe["filename"] = "LinLibertine_R"
libertineRe["familyname"] = "Linux Libertine O"
libertineRe["fullname"] = "Linux Libertine O"
libertineRe["weight"] = "Book"
libertineRe["style"] = "Regular"

# Linux Libertine Slanted
libertineRe["slfilename"] = "LinLibertine_aRL"
libertineRe["slfontname"] = "LinLibertineSlantedO"
libertineRe["slfamilyname"] = "Linux Libertine Slanted O"
libertineRe["slfullname"] = "Linux Libertine Slanted O"
libertineRe["slweight"] = "Book"
libertineRe["slstyle"] = "Slanted"

# Linux Libertine Small Caps
libertineRe["scfilename"] = "LinLibertine_aS"
libertineRe["scfontname"] = "LinLibertineCapitalsO"
libertineRe["scfamilyname"] = "Linux Libertine Capitals O"
libertineRe["scfullname"] = "Linux Libertine Capitals O"
libertineRe["scweight"] = "Book"
libertineRe["scstyle"] = "Small Caps"

# Linux Libertine Regular (TrueType)
libertineRe["ttffontname"] = "LinLibertine"
libertineRe["ttffamilyname"] = "Linux Libertine"
libertineRe["ttffullname"] = "Linux Libertine"
libertineRe["ttfweight"] = "Book"
libertineRe["ttfstyle"] = "Regular"

# Name der TEX-Datei
libertineRe["texfilename"] = "fxlr"

# Füge Einträge der Liste hinzu
fonts["LinLibertineO"] = libertineRe;

libertineReSl = {};
libertineReSl["ttffontname"] = "LinLibertineSlanted"
libertineReSl["ttffamilyname"] = "Linux Libertine Slanted"
libertineReSl["ttffullname"] = "Linux Libertine Slanted"
libertineReSl["ttfweight"] = "Book"
libertineReSl["ttfstyle"] = "Slanted"
libertineReSl["texfilename"] = "fxlro"
fonts["LinLibertineSlantedO"] = libertineReSl;

libertineReSc = {};
libertineReSc["ttffontname"] = "LinLibertineCapitals"
libertineReSc["ttffamilyname"] = "Linux Libertine Capitals"
libertineReSc["ttffullname"] = "Linux Libertine Capitals"
libertineReSc["ttfweight"] = "Book"
libertineReSc["ttfstyle"] = "Small Caps"
fonts["LinLibertineCapitalsO"] = libertineReSc;


# LIBERTINE Semibold
libertineZ = {};
libertineZ["filename"] = "LinLibertine_RZ"
libertineZ["familyname"] = "Linux Libertine O"
libertineZ["fullname"] = "Linux Libertine O Semibold"
libertineZ["weight"] = "Semibold"
libertineZ["style"] = "Semibold"
libertineZ["slfilename"] = "LinLibertine_aZL"
libertineZ["slfontname"] = "LinLibertineSlantedOZ"
libertineZ["slfamilyname"] = "Linux Libertine Slanted O"
libertineZ["slfullname"] = "Linux Libertine Slanted O Semibold"
libertineZ["slweight"] = "Semibold"
libertineZ["slstyle"] = "Semibold Slanted"
libertineZ["scfilename"] = "LinLibertine_aZS"
libertineZ["scfontname"] = "LinLibertineCapitalsOZ"
libertineZ["scfamilyname"] = "Linux Libertine Capitals O"
libertineZ["scfullname"] = "Linux Libertine Capitals O Semibold"
libertineZ["scweight"] = "Semibold"
libertineZ["scstyle"] = "Semibold Small Caps"

libertineZ["ttffontname"] = "LinLibertineZ"
libertineZ["ttffamilyname"] = "Linux Libertine"
libertineZ["ttffullname"] = "Linux Libertine Semibold"
libertineZ["ttfweight"] = "Semibold"
libertineZ["ttfstyle"] = "Semibold"
libertineZ["texfilename"] = "fxlz"
fonts["LinLibertineOZ"] = libertineZ;

libertineZSl = {};
libertineZSl["ttffontname"] = "LinLibertineSlantedZ"
libertineZSl["ttffamilyname"] = "Linux Libertine Slanted"
libertineZSl["ttffullname"] = "Linux Libertine Slanted Semibold"
libertineZSl["ttfweight"] = "Semibold"
libertineZSl["ttfstyle"] = "Semibold Slanted"
libertineZSl["texfilename"] = "fxlzo"
fonts["LinLibertineSlantedOZ"] = libertineZSl;


# LIBERTINE SemiBold Italic
libertineZi = {};
libertineZi["filename"] = "LinLibertine_RZI"
libertineZi["familyname"] = "Linux Libertine O"
libertineZi["fullname"] = "Linux Libertine O Semibold Italic"
libertineZi["weight"] = "Semibold"
libertineZi["style"] = "Semibold Italic"
libertineZi["scfilename"] = "LinLibertine_aSZI"
libertineZi["scfontname"] = "LinLibertineCapitalsOSZI"
libertineZi["scfamilyname"] = "Linux Libertine Capitals O"
libertineZi["scfullname"] = "Linux Libertine Capitals O Semibold Italic"
libertineZi["scweight"] = "Semibold"
libertineZi["scstyle"] = "Semibold Italic Samll Caps"
libertineZi["ttffontname"] = "LinLibertineZI"
libertineZi["ttffamilyname"] = "Linux Libertine"
libertineZi["ttffullname"] = "Linux Libertine Semibold Italic"
libertineZi["ttfweight"] = "Semibold"
libertineZi["ttfstyle"] = "Semibold Italic"
libertineZi["texfilename"] = "fxlzi"
fonts["LinLibertineOZI"] = libertineZi;

libertineZiSc = {};
libertineZiSc["ttffontname"] = "LinLibertineCapitalsZI"
libertineZiSc["ttffamilyname"] = "Linux Libertine Capitals"
libertineZiSc["ttffullname"] = "Linux Libertine Capitals Semibold Italic"
libertineZiSc["ttfweight"] = "Semibold"
libertineZiSc["ttfstyle"] = "Semibold Italic Small Caps"
fonts["LinLibertineCapitalsOSZI"] = libertineZiSc;





# LIBERTINE Bold
libertineBd = {};
libertineBd["filename"] = "LinLibertine_RB"
libertineBd["familyname"] = "Linux Libertine O"
libertineBd["fullname"] = "Linux Libertine O Bold"
libertineBd["weight"] = "Bold"
libertineBd["style"] = "Bold"
libertineBd["slfilename"] = "LinLibertine_aBL"
libertineBd["slfontname"] = "LinLibertineSlantedOB"
libertineBd["slfamilyname"] = "Linux Libertine Slanted O"
libertineBd["slfullname"] = "Linux Libertine Slanted O Bold"
libertineBd["slweight"] = "Bold"
libertineBd["slstyle"] = "Bold Slanted"
libertineBd["scfilename"] = "LinLibertine_aBS"
libertineBd["scfontname"] = "LinLibertineCapitalsOB"
libertineBd["scfamilyname"] = "Linux Libertine Capitals O"
libertineBd["scfullname"] = "Linux Libertine Capitals O Bold"
libertineBd["scweight"] = "Bold"
libertineBd["scstyle"] = "Bold Small Caps"

libertineBd["ttffontname"] = "LinLibertineB"
libertineBd["ttffamilyname"] = "Linux Libertine"
libertineBd["ttffullname"] = "Linux Libertine Bold"
libertineBd["ttfweight"] = "Bold"
libertineBd["ttfstyle"] = "Bold"
libertineBd["texfilename"] = "fxlb"
fonts["LinLibertineOB"] = libertineBd;

libertineBdSl = {};
libertineBdSl["ttffontname"] = "LinLibertineSlantedB"
libertineBdSl["ttffamilyname"] = "Linux Libertine Slanted"
libertineBdSl["ttffullname"] = "Linux Libertine Slanted Bold"
libertineBdSl["ttfweight"] = "Bold"
libertineBdSl["ttfstyle"] = "Bold Slanted"
libertineBdSl["texfilename"] = "fxlbo"
fonts["LinLibertineSlantedOB"] = libertineBdSl;

libertineBdSc = {};
libertineBdSc["ttffontname"] = "LinLibertineCapitalsB"
libertineBdSc["ttffamilyname"] = "Linux Libertine Capitals"
libertineBdSc["ttffullname"] = "Linux Libertine Capitals Bold"
libertineBdSc["ttfweight"] = "Bold"
libertineBdSc["ttfstyle"] = "Bold Small Caps"
fonts["LinLibertineCapitalsOB"] = libertineBdSc;

# LIBERTINE Italic
libertineIt = {};
libertineIt["filename"] = "LinLibertine_RI"
libertineIt["familyname"] = "Linux Libertine O"
libertineIt["fullname"] = "Linux Libertine O Italic"
libertineIt["weight"] = "Book"
libertineIt["style"] = "Italic"
libertineIt["scfilename"] = "LinLibertine_aSI"
libertineIt["scfontname"] = "LinLibertineCapitalsOI"
libertineIt["scfamilyname"] = "Linux Libertine Capitals O"
libertineIt["scfullname"] = "Linux Libertine Capitals O Italic"
libertineIt["scweight"] = "Book"
libertineIt["scstyle"] = "Italic"

libertineIt["ttffontname"] = "LinLibertineI"
libertineIt["ttffamilyname"] = "Linux Libertine"
libertineIt["ttffullname"] = "Linux Libertine Italic"
libertineIt["ttfweight"] = "Book"
libertineIt["ttfstyle"] = "Italic"
libertineIt["texfilename"] = "fxlri"
fonts["LinLibertineOI"] = libertineIt;

libertineItSc = {};
libertineItSc["ttffontname"] = "LinLibertineCapitalsI"
libertineItSc["ttffamilyname"] = "Linux Libertine Capitals"
libertineItSc["ttffullname"] = "Linux Libertine Capitals Italic"
libertineItSc["ttfweight"] = "Book"
libertineItSc["ttfstyle"] = "Small Caps"
fonts["LinLibertineCapitalsOI"] = libertineItSc;

# LIBERTINE Bold Italic
#libertineBi = {};
#libertineBi["filename"] = "LinLibertine_RBI"
#libertineBi["familyname"] = "Linux Libertine O"
#libertineBi["fullname"] = "Linux Libertine O Bold Italic"
#libertineBi["weight"] = "Bold"
#libertineBi["style"] = "Bold Italic"
#libertineBi["scfilename"] = "LinLibertine_aSBI"
#libertineBi["scfontname"] = "LinLibertineCapitalsOSBI"
#libertineBi["scfamilyname"] = "Linux Libertine Capitals O"
#libertineBi["scfullname"] = "Linux Libertine Capitals O Bold Italic"
#libertineBi["scweight"] = "Bold"
#libertineBi["scstyle"] = "Bold Italic Samll Caps"
#libertineBi["ttffontname"] = "LinLibertineBI"
#libertineBi["ttffamilyname"] = "Linux Libertine"
#libertineBi["ttffullname"] = "Linux Libertine Bold Italic"
#libertineBi["ttfweight"] = "Bold"
#libertineBi["ttfstyle"] = "Bold Italic"
#libertineBi["texfilename"] = "fxlbi"
#fonts["LinLibertineOBI"] = libertineBi;

#libertineBiSc = {};
#libertineBiSc["ttffontname"] = "LinLibertineCapitalsBI"
#libertineBiSc["ttffamilyname"] = "Linux Libertine Capitals"
#libertineBiSc["ttffullname"] = "Linux Libertine Capitals Bold Italic"
#libertineBiSc["ttfweight"] = "Bold"
#libertineBiSc["ttfstyle"] = "Bold Italic Small Caps"
#fonts["LinLibertineCapitalsOBI"] = libertineBiSc;

#####################################################################
#####################################################################
# BIOLINUM
biolinumRe = {};
biolinumRe["filename"] = "LinBiolinum_R"
biolinumRe["familyname"] = "Linux Biolinum O"
biolinumRe["fullname"] = "Linux Biolinum O"
biolinumRe["weight"] = "Book"
biolinumRe["style"] = "Regular"
biolinumRe["slfilename"] = "LinBiolinum_aRL"
biolinumRe["slfontname"] = "LinBiolinumSlantedO"
biolinumRe["slfamilyname"] = "Linux Biolinum Slanted O"
biolinumRe["slfullname"] = "Linux Biolinum Slanted O"
biolinumRe["slweight"] = "Book"
biolinumRe["slstyle"] = "Slanted"
biolinumRe["scfilename"] = "LinBiolinum_aS"
biolinumRe["scfontname"] = "LinBiolinumCapitalsO"
biolinumRe["scfamilyname"] = "Linux Biolinum Capitals O"
biolinumRe["scfullname"] = "Linux Biolinum Capitals O"
biolinumRe["scweight"] = "Book"
biolinumRe["scstyle"] = "Small Caps"
biolinumRe["ttffontname"] = "LinBiolinum"
biolinumRe["ttffamilyname"] = "Linux Biolinum"
biolinumRe["ttffullname"] = "Linux Biolinum"
biolinumRe["ttfweight"] = "Book"
biolinumRe["ttfstyle"] = "Regular"
biolinumRe["texfilename"] = "fxbr"
biolinumRe["outfilename"] = "LinBiolinum_aU"
biolinumRe["outfontname"] = "LinBiolinumUO"
biolinumRe["outfamilyname"] = "Linux Biolinum Outline O"
biolinumRe["outfullname"] = "Linux Biolinum Outline O"
biolinumRe["outweight"] = "Book"
biolinumRe["outstyle"] = "Outline"
biolinumRe["shfilename"] = "LinBiolinum_aW"
biolinumRe["shfontname"] = "LinBiolinumWO"
biolinumRe["shfamilyname"] = "Linux Biolinum Shadow O"
biolinumRe["shfullname"] = "Linux Biolinum Shadow O"
biolinumRe["shweight"] = "Book"
biolinumRe["shstyle"] = "Shadow"
fonts["LinBiolinumO"] = biolinumRe;

biolinumReSh = {};
biolinumReSh["ttffontname"] = "LinBiolinumW"
biolinumReSh["ttffamilyname"] = "Linux Biolinum Shadow"
biolinumReSh["ttffullname"] = "Linux Biolinum Shadow"
biolinumReSh["ttfweight"] = "Book"
biolinumReSh["ttfstyle"] = "Shadow"
biolinumReSh["texfilename"] = "fxbs"
fonts["LinBiolinumWO"] = biolinumReSh;

biolinumReOut = {};
biolinumReOut["ttffontname"] = "LinBiolinumU"
biolinumReOut["ttffamilyname"] = "Linux Biolinum Outline"
biolinumReOut["ttffullname"] = "Linux Biolinum Outline"
biolinumReOut["ttfweight"] = "Book"
biolinumReOut["ttfstyle"] = "Outline"
biolinumReOut["texfilename"] = "fxbo"
fonts["LinBiolinumUO"] = biolinumReOut;

biolinumReSl = {};
biolinumReSl["ttffontname"] = "LinBiolinumSlanted"
biolinumReSl["ttffamilyname"] = "Linux Biolinum Slanted"
biolinumReSl["ttffullname"] = "Linux Biolinum Slanted"
biolinumReSl["ttfweight"] = "Book"
biolinumReSl["ttfstyle"] = "Slanted"
biolinumReSl["texfilename"] = "fxbro"
fonts["LinBiolinumSlantedO"] = biolinumReSl;

biolinumReSc = {};
biolinumReSc["ttffontname"] = "LinBiolinumCapitals"
biolinumReSc["ttffamilyname"] = "Linux Biolinum Capitals"
biolinumReSc["ttffullname"] = "Linux Biolinum Capitals"
biolinumReSc["ttfweight"] = "Book"
biolinumReSc["ttfstyle"] = "Samll Caps"
fonts["LinBiolinumCapitalsO"] = biolinumReSc;

# BIOLINUM Italic
biolinumIt = {};
biolinumIt["filename"] = "LinBiolinum_RI"
biolinumIt["familyname"] = "Linux Biolinum O"
biolinumIt["fullname"] = "Linux Biolinum O Italic"
biolinumIt["weight"] = "Book"
biolinumIt["style"] = "Italic"
biolinumIt["scfilename"] = "LinBiolinum_aSI"
biolinumIt["scfontname"] = "LinBiolinumCapitalsOI"
biolinumIt["scfamilyname"] = "Linux Biolinum Capitals O"
biolinumIt["scfullname"] = "Linux Biolinum Capitals O Italic"
biolinumIt["scweight"] = "Book"
biolinumIt["scstyle"] = "Italic Samll Caps"
biolinumIt["ttffontname"] = "LinBiolinumI"
biolinumIt["ttffamilyname"] = "Linux Biolinum"
biolinumIt["ttffullname"] = "Linux Biolinum Italic"
biolinumIt["ttfweight"] = "Book"
biolinumIt["ttfstyle"] = "Italic"
biolinumIt["texfilename"] = "fxbri"
biolinumIt["outfilename"] = "LinBiolinum_aUI"
biolinumIt["outfontname"] = "LinBiolinumUOI"
biolinumIt["outfamilyname"] = "Linux Biolinum Outline O"
biolinumIt["outfullname"] = "Linux Biolinum Outline O Italic"
biolinumIt["outweight"] = "Book"
biolinumIt["outstyle"] = "Outline Italic"
biolinumIt["shfilename"] = "LinBiolinum_aWI"
biolinumIt["shfontname"] = "LinBiolinumWOI"
biolinumIt["shfamilyname"] = "Linux Biolinum Shadow O"
biolinumIt["shfullname"] = "Linux Biolinum Shadow O Italic"
biolinumIt["shweight"] = "Book"
biolinumIt["shstyle"] = "Shadow Italic"
fonts["LinBiolinumOI"] = biolinumIt;

biolinumItSh = {};
biolinumItSh["ttffontname"] = "LinBiolinumWI"
biolinumItSh["ttffamilyname"] = "Linux Biolinum Shadow"
biolinumItSh["ttffullname"] = "Linux Biolinum Shadow Italic"
biolinumItSh["ttfweight"] = "Book"
biolinumItSh["ttfstyle"] = "Shadow Italic"
biolinumItSh["texfilename"] = "fxbsi"
fonts["LinBiolinumWOI"] = biolinumItSh;

biolinumItOut = {};
biolinumItOut["ttffontname"] = "LinBiolinumUI"
biolinumItOut["ttffamilyname"] = "Linux Biolinum Outline"
biolinumItOut["ttffullname"] = "Linux Biolinum Outline Italic"
biolinumItOut["ttfweight"] = "Book"
biolinumItOut["ttfstyle"] = "Outline Italic"
biolinumItOut["texfilename"] = "fxboi"
fonts["LinBiolinumUOI"] = biolinumItOut;

biolinumItSc = {};
biolinumItSc["ttffontname"] = "LinBiolinumCapitalsI"
biolinumItSc["ttffamilyname"] = "Linux Biolinum Capitals"
biolinumItSc["ttffullname"] = "Linux Biolinum Capitals Italic"
biolinumItSc["ttfweight"] = "Book"
biolinumItSc["ttfstyle"] = "Italic Small Caps"
fonts["LinBiolinumCapitalsOI"] = biolinumReSc;

# BIOLINUM Bold
biolinumBd = {};
biolinumBd["filename"] = "LinBiolinum_RB"
biolinumBd["familyname"] = "Linux Biolinum O"
biolinumBd["fullname"] = "Linux Biolinum O Bold"
biolinumBd["weight"] = "Bold"
biolinumBd["style"] = "Bold"
biolinumBd["slfilename"] = "LinBiolinum_aBL"
biolinumBd["slfontname"] = "LinBiolinumSlantedOB"
biolinumBd["slfamilyname"] = "Linux Biolinum Slanted O"
biolinumBd["slfullname"] = "Linux Biolinum Slanted O Bold"
biolinumBd["slweight"] = "Bold"
biolinumBd["slstyle"] = "Bold Slanted"
biolinumBd["scfilename"] = "LinBiolinum_aSB"
biolinumBd["scfontname"] = "LinBiolinumCapitalsOB"
biolinumBd["scfamilyname"] = "Linux Biolinum Capitals O"
biolinumBd["scfullname"] = "Linux Biolinum Capitals O Bold"
biolinumBd["scweight"] = "Bold"
biolinumBd["scstyle"] = "Bold Small Caps"
biolinumBd["ttffontname"] = "LinBiolinumB"
biolinumBd["ttffamilyname"] = "Linux Biolinum"
biolinumBd["ttffullname"] = "Linux Biolinum Bold"
biolinumBd["ttfweight"] = "Bold"
biolinumBd["ttfstyle"] = "Bold"
biolinumBd["texfilename"] = "fxbb"
biolinumBd["outfilename"] = "LinBiolinum_aUB"
biolinumBd["outfontname"] = "LinBiolinumUOB"
biolinumBd["outfamilyname"] = "Linux Biolinum Outline O"
biolinumBd["outfullname"] = "Linux Biolinum Outline O Bold"
biolinumBd["outweight"] = "Bold"
biolinumBd["outstyle"] = "Bold"
biolinumBd["shfilename"] = "LinBiolinum_aWB"
biolinumBd["shfontname"] = "LinBiolinumWOB"
biolinumBd["shfamilyname"] = "Linux Biolinum Shadow O"
biolinumBd["shfullname"] = "Linux Biolinum Shadow O Bold"
biolinumBd["shweight"] = "Bold"
biolinumBd["shstyle"] = "Bold"
fonts["LinBiolinumOB"] = biolinumBd;

biolinumBdSh = {};
biolinumBdSh["ttffontname"] = "LinBiolinumShadowB"
biolinumBdSh["ttffamilyname"] = "Linux Biolinum Shadow"
biolinumBdSh["ttffullname"] = "Linux Biolinum Shadow Bold"
biolinumBdSh["ttfweight"] = "Bold"
biolinumBdSh["ttfstyle"] = "Bold"
biolinumBdSh["texfilename"] = "fxbsb"
fonts["LinBiolinumWOB"] = biolinumBdSh;


#Stimmt hier was nicht?:
biolinumBdOut = {};
biolinumBdOut["ttffontname"] = "LinBiolinumSlantedB"
biolinumBdOut["ttffamilyname"] = "Linux Biolinum Slanted"
biolinumBdOut["ttffullname"] = "Linux Biolinum Slanted Bold"
biolinumBdOut["ttfweight"] = "Bold"
biolinumBdOut["ttfstyle"] = "Bold Slanted"
biolinumBdOut["texfilename"] = "fxbob"
fonts["LinBiolinumUOB"] = biolinumBdOut;

biolinumBdSl = {};
biolinumBdSl["ttffontname"] = "LinBiolinumSlantedB"
biolinumBdSl["ttffamilyname"] = "Linux Biolinum Slanted"
biolinumBdSl["ttffullname"] = "Linux Biolinum Slanted Bold"
biolinumBdSl["ttfweight"] = "Bold"
biolinumBdSl["ttfstyle"] = "Bold Slanted"
biolinumBdSl["texfilename"] = "fxbbo"
fonts["LinBiolinumSlantedOB"] = biolinumBdSl;

biolinumBdSc = {};
biolinumBdSc["ttffontname"] = "LinBiolinumCapitalsB"
biolinumBdSc["ttffamilyname"] = "Linux Biolinum Capitals"
biolinumBdSc["ttffullname"] = "Linux Biolinum Capitals Bold"
biolinumBdSc["ttfweight"] = "Bold"
biolinumBdSc["ttfstyle"] = "Bold Small Caps"
fonts["LinBiolinumCapitalsOB"] = biolinumBdSc;

# BIOLINUM
biolinumKb = {};
biolinumKb["filename"] = "LinBiolinum_K"
biolinumKb["familyname"] = "Linux Biolinum Keyboard O"
biolinumKb["fullname"] = "Linux Biolinum Keyboard O"
biolinumKb["weight"] = "Book"
biolinumKb["style"] = "Regular"
biolinumKb["ttffontname"] = "LinBiolinumK"
biolinumKb["ttffamilyname"] = "Linux Biolinum Keyboard"
biolinumKb["ttffullname"] = "Linux Biolinum Keyboard"
biolinumKb["ttfweight"] = "Book"
biolinumKb["ttfstyle"] = "Regular"
biolinumKb["texfilename"] = "fxbk"
fonts["LinBiolinumOKb"] = biolinumKb;

# BIOLINUM Outline
biolinumOT = {};
biolinumOT["filename"] = "LinBiolinum_aU"
biolinumOT["familyname"] = "Linux Biolinum Outline O"
biolinumOT["fullname"] = "Linux Biolinum Outline O"
biolinumOT["weight"] = "Book"
biolinumOT["style"] = "Regular"
biolinumOT["slfilename"] = "LinBiolinum_aUL"
biolinumOT["slfontname"] = "LinBiolinumSlantedULO"
biolinumOT["slfamilyname"] = "Linux Biolinum Outline Slanted O"
biolinumOT["slfullname"] = "Linux Biolinum Outline Slanted O"
biolinumOT["slweight"] = "Book"
biolinumOT["slstyle"] = "Slanted"
biolinumOT["ttffontname"] = "LinBiolinumU"
biolinumOT["ttffamilyname"] = "Linux Biolinum Outline"
biolinumOT["ttffullname"] = "Linux Biolinum Outline"
biolinumOT["ttfweight"] = "Book"
biolinumOT["ttfweight"] = "Regular"
biolinumOT["texfilename"] = "fxbo"
fonts["LinBiolinumOO"] = biolinumOT;

biolinumOTSl = {};
biolinumOTSl["ttffontname"] = "LinLibertineUSlanted"
biolinumOTSl["ttffamilyname"] = "Linux Biolinum Outline Slanted"
biolinumOTSl["ttffullname"] = "Linux Biolinum Outline Slanted"
biolinumOTSl["ttfweight"] = "Book"
biolinumOTSl["ttfstyle"] = "Slanted"
biolinumOTSl["texfilename"] = "fxboo"
fonts["LinBiolinumSlantedULO"] = biolinumOTSl;

# BIOLINUM Shadow
biolinumSH = {};
biolinumSH["filename"] = "LinBiolinum_aW"
biolinumSH["familyname"] = "Linux Biolinum Shadow O"
biolinumSH["fullname"] = "Linux Biolinum Shadow O"
biolinumSH["weight"] = "Book"
biolinumSH["style"] = "Regular"
biolinumSH["slfilename"] = "LinBiolinum_aWL"
biolinumSH["slfontname"] = "LinBiolinumSlantedWL"
biolinumSH["slfamilyname"] = "Linux Biolinum Shadow Slanted O"
biolinumSH["slfullname"] = "Linux Biolinum Shadow Slanted O"
biolinumSH["slweight"] = "Book"
biolinumSH["slstyle"] = "Slanted"
biolinumSH["ttffontname"] = "LinBiolinumW"
biolinumSH["ttffamilyname"] = "Linux Biolinum Shadow"
biolinumSH["ttffullname"] = "Linux Biolinum Shadow"
biolinumSH["ttfweight"] = "Book"
biolinumSH["ttfstyle"] = "Regular"
biolinumSH["texfilename"] = "fxbs"
fonts["LinBiolinumWO"] = biolinumSH;

biolinumSHSl = {};
biolinumSHSl["ttffontname"] = "LinLibertineWSlanted"
biolinumSHSl["ttffamilyname"] = "Linux Biolinum Shadow Slanted"
biolinumSHSl["ttffullname"] = "Linux Biolinum Shadow Slanted"
biolinumSHSl["ttfweight"] = "Book"
biolinumSHSl["ttfstyle"] = "Slanted"
biolinumSHSl["texfilename"] = "fxbso"
fonts["LinBiolinumSlantedWL"] = biolinumSHSl;

