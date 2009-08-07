#!/usr/bin/env fontforge
# -*- coding: utf-8 -*-
#
# kopiert den sfd Libertine-Font
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
version = re.sub('(?P<name>.*)_(?P<weight>.*)-(?P<version>[0-9\.]*).sfd', '\g<version>', sys.argv[1])

filename = "XXX"

if fnt.fontname == "LinLibertineO":
   filename = "LinLibertine_Re"
   fnt.familyname = "Linux Libertine O"   
   fnt.fullname = "Linux Libertine O"
   fnt.weight = "Book"
elif fnt.fontname == "LinLibertineOB":
   filename = "LinLibertine_Bd"
   fnt.familyname = "Linux Libertine O"   
   fnt.fullname = "Linux Libertine O Bold"
   fnt.weight = "Bold"
elif fnt.fontname == "LinLibertineOI":
   filename = "LinLibertine_It"
   fnt.familyname = "Linux Libertine O"   
   fnt.fullname = "Linux Libertine O Italic"
   fnt.weight = "Book"
elif fnt.fontname == "LinLibertineOBI":
   filename = "LinLibertine_BI"
   fnt.familyname = "Linux Libertine O"   
   fnt.fullname = "Linux Libertine O Bold Italic"
   fnt.weight = "Book"
elif fnt.fontname == 'LinLibertineOC':
   filename = "LinLibertine_C"
   fnt.familyname = "Linux Libertine O C"   
   fnt.fullname = "Linux Libertine O Capitals"
   fnt.weight = "Book"
elif fnt.fontname == "LinBiolinumO":
   filename = "LinBiolinum_Re"
   fnt.familyname = "Linux Biolinum O"   
   fnt.fullname = "Linux Biolinum O"
   fnt.weight = "Book"
elif fnt.fontname == "LinBiolinumOB":
   filename = "LinBiolinum_Bd"
   fnt.familyname = "Linux Biolinum O"   
   fnt.fullname = "Linux Biolinum O Bold"
   fnt.weight = "Bold"
elif fnt.fontname == "LinBiolinumOKb":
   filename = "LinBiolinum_Kb"
   fnt.familyname = "Linux Biolinum O Kb"   
   fnt.fullname = "Linux Biolinum O Keyboard"
   fnt.weight = "Regular"
else: 
    sys.exit("Fontname " + fnt.fntname + " unknown")
    
fnt.copyright = "Linux Libertine by Philipp H. Poll,\nOpen Font under Terms of following Free Software Licenses:\nGPL (General Public License) with font-exception and OFL (Open Font License).\nCreated with FontForge (http://fontforge.sf.net)\nSept 2003, 2004, 2005, 2006, 2007, 2008, 2009" 
fnt.version = version

fnt.selection.all()
for layer in fnt.layers:
    fnt.layers[layer].is_quadratic = False
    fnt.layers[layer].is_background = False
    
fnt.unlinkReferences()
fnt.removeOverlap()
fnt.round(10)
fnt.em = 1000

outname = sys.argv[2] + "/" + filename + "-" + version + ".sfd"
fnt.save(outname)
print "    saved as " + outname

# namelist
if fnt.fontname == "LinLibertineO" or fnt.fontname == "LinBiolinumO":
    outname = sys.argv[2] + "/" + fnt.fontname + ".nam"
    print "    create " + outname
    fnt.saveNamelist(outname)

# create slanted
angle = psMat.skew(math.radians(12))
newfontname = "XXX"
if fnt.fontname == "LinLibertineO":
   filename = "LinLibertine_Sl"
   newfontname = "LinLibertineOSl"
   fnt.familyname = "Linux Libertine O"   
   fnt.fullname = "Linux Libertine O Slanted"
   fnt.weight = "Book"
elif fnt.fontname == "LinLibertineOB":
   filename = "LinLibertine_BSl"
   newfontname = "LinLibertineOBSl"
   fnt.familyname = "Linux Libertine O"   
   fnt.fullname = "Linux Libertine O Bold Slanted"
   fnt.weight = "Bold"
elif fnt.fontname == "LinBiolinumO":
   filename = "LinBiolinum_Sl"
   newfontname = "LinBiolinumOSl"
   fnt.familyname = "Linux Biolinum O"   
   fnt.fullname = "Linux Biolinum O Slanted"
   fnt.weight = "Book"
elif fnt.fontname == "LinBiolinumOB":
   filename = "LinBiolinum_BSl"
   newfontname = "LinBiolinumOBSl"
   fnt.familyname = "Linux Biolinum O"   
   fnt.fullname = "Linux Biolinum O Bold Slanted"
   fnt.weight = "Bold"

if newfontname != "XXX":
    fnt.fontname = newfontname
    fnt.selection.all()
    fnt.transform(angle)
    outname = sys.argv[2] + "/" + filename + "-" + version + ".sfd"
    fnt.save(outname)
    print "    saved as " + outname



