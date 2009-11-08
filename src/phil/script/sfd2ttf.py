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
elif fnt.fontname == "LinLibertineSlantedO":
   newfontname = "LinLibertineSlanted"
   fnt.familyname = "Linux Libertine Slanted"   
   fnt.fullname = "Linux Libertine Slanted"
   fnt.weight = "Book"
elif fnt.fontname == "LinLibertineOB":
   newfontname = "LinLibertineB"
   fnt.familyname = "Linux Libertine"   
   fnt.fullname = "Linux Libertine Bold"
   fnt.weight = "Bold"
elif fnt.fontname == "LinLibertineSlantedOB":
   newfontname = "LinLibertineSlantedB"
   fnt.familyname = "Linux Libertine Slanted"   
   fnt.fullname = "Linux Libertine Slanted Bold"
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
elif fnt.fontname == "LinBiolinumOI":
   newfontname = "LinBiolinumI"
   fnt.familyname = "Linux Biolinum"   
   fnt.fullname = "Linux Biolinum Italic"
   fnt.weight = "Book"
elif fnt.fontname == "LinBiolinumSlantedO":
   newfontname = "LinBiolinumSlanted"
   fnt.familyname = "Linux Biolinum Slanted"   
   fnt.fullname = "Linux Biolinum Slanted"
   fnt.weight = "Book"
elif fnt.fontname == "LinBiolinumOB":
   newfontname = "LinBiolinumB"
   fnt.familyname = "Linux Biolinum"   
   fnt.fullname = "Linux Biolinum Bold"
   fnt.weight = "Bold"
elif fnt.fontname == "LinBiolinumSlantedOB":
   newfontname = "LinBiolinumSlantedB"
   fnt.familyname = "Linux Biolinum Slanted"   
   fnt.fullname = "Linux Biolinum Slanted Bold"
   fnt.weight = "Bold"
elif fnt.fontname == "LinBiolinumOKb":
   newfontname = "LinBiolinumKb"
   fnt.familyname = "Linux Biolinum Kb"   
   fnt.fullname = "Linux Biolinum Keyboard"
   fnt.weight = "Regular"
else: 
    sys.exit("Fontname " + fnt.fontname + " unknown")

fnt.fontname = newfontname;

fnt.selection.all()
for layer in fnt.layers:
    fnt.layers[layer].is_quadratic = True
    fnt.layers[layer].is_background = False
    
fnt.em = 2048
fnt.round(1)
fnt.autoInstr()


basename = os.path.basename(sys.argv[1])
filename = re.sub('(?P<name>.*)\.sfd', '\g<name>', basename)
outname = sys.argv[2] + "/" + filename + ".ttf"
print "    generate " + outname
fnt.generate(outname)
