#!/usr/bin/env fontforge
# -*- coding: utf-8 -*-
#
# wandelt sfd in ttf um
#
# $1 sfd-file
# $2 output-dir
#
# $Id$
#
# Michael Niedermair m.g.n@gmx.de
#
import fontforge
import psMat
import sys
import os
import re
import math

if len(sys.argv) < 3:
    sys.exit(sys.argv[0] + ' <sfd-file> <output-dir>')
if not os.path.isdir(sys.argv[2]):
    sys.exit(sys.argv[2] + ' is not a valid dir!')
if not os.path.isfile(sys.argv[1]):
    sys.exit(sys.argv[1] + ' is not a valid file!')
    

fnt = fontforge.open(sys.argv[1])

print "### " + sys.argv[1]

newfontname = "XXX"
if fnt.fontname == "LinLibertineO":
   newfontname = "LinLibertine"
   fnt.familyname = "Linux Libertine"   
   fnt.fullname = "Linux Libertine"
   fnt.weight = "Book"
elif fnt.fontname == "LinLibertineOSl":
   newfontname = "LinLibertineSl"
   fnt.familyname = "Linux Libertine"   
   fnt.fullname = "Linux Libertine Slanted"
   fnt.weight = "Book"
elif fnt.fontname == "LinLibertineOB":
   newfontname = "LinLibertineB"
   fnt.familyname = "Linux Libertine"   
   fnt.fullname = "Linux Libertine Bold"
   fnt.weight = "Bold"
elif fnt.fontname == "LinLibertineOBSl":
   newfontname = "LinLibertineBSl"
   fnt.familyname = "Linux Libertine"   
   fnt.fullname = "Linux Libertine Bold Slanted"
   fnt.weight = "Bold"
elif fnt.fontname == "LinLibertineOI":
   newfontname = "LinLibertineI"
   fnt.familyname = "Linux Libertine"   
   fnt.fullname = "Linux Libertine Italic"
   fnt.weight = "Book"
elif fnt.fontname == "LinLibertineOBI":
   newfontname = "LinLibertineBI"
   fnt.familyname = "Linux Libertine"   
   fnt.fullname = "Linux Libertine Bold Italic"
   fnt.weight = "Book"
elif fnt.fontname == 'LinLibertineOC':
   newfontname = "LinLibertineC"
   fnt.familyname = "Linux Libertine C"   
   fnt.fullname = "Linux Libertine Capitals"
   fnt.weight = "Book"
elif fnt.fontname == "LinBiolinumO":
   newfontname = "LinBiolinum"
   fnt.familyname = "Linux Biolinum"   
   fnt.fullname = "Linux Biolinum"
   fnt.weight = "Book"
elif fnt.fontname == "LinBiolinumOSl":
   newfontname = "LinBiolinumSl"
   fnt.familyname = "Linux Biolinum"   
   fnt.fullname = "Linux Biolinum Slanted"
   fnt.weight = "Book"
elif fnt.fontname == "LinBiolinumOB":
   newfontname = "LinBiolinumB"
   fnt.familyname = "Linux Biolinum"   
   fnt.fullname = "Linux Biolinum Bold"
   fnt.weight = "Bold"
elif fnt.fontname == "LinBiolinumOBSl":
   newfontname = "LinBiolinumBSl"
   fnt.familyname = "Linux Biolinum"   
   fnt.fullname = "Linux Biolinum Bold Slanted"
   fnt.weight = "Bold"
elif fnt.fontname == "LinBiolinumOKb":
   newfontname = "LinBiolinumKb"
   fnt.familyname = "Linux Biolinum Kb"   
   fnt.fullname = "Linux Biolinum Keyboard"
   fnt.weight = "Regular"
else: 
    sys.exit("Fontname " + fnt.fntname + " unknown")

fnt.fontname = newfontname;

fnt.selection.all()
for layer in fnt.layers:
    fnt.layers[layer].is_quadratic = True
    fnt.layers[layer].is_background = False
    
fnt.unlinkReferences()
fnt.removeOverlap()
fnt.round(10)
fnt.em = 2048
fnt.autoInstr()


basename = os.path.basename(sys.argv[1])
filename = re.sub('(?P<name>.*)\.sfd', '\g<name>', basename)
outname = sys.argv[2] + "/" + filename + ".ttf"
print "    generate " + outname
fnt.generate(outname)
