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
import libertine

if len(sys.argv) < 3:
    sys.exit(sys.argv[0] + ' <sfd-file> <output-dir>')
if not os.path.isdir(sys.argv[2]):
    sys.exit(sys.argv[2] + ' is not a valid dir!')
if not os.path.isfile(sys.argv[1]):
    sys.exit(sys.argv[1] + ' is not a valid file!')

fnt = fontforge.open(sys.argv[1])

print "### " + sys.argv[1]

version = re.sub('(?P<name>.*)_(?P<weight>.*)-(?P<version>[0-9\.]*).sfd', '\g<version>', sys.argv[1])

if libertine.fonts.has_key(fnt.fontname) == False:
   print "### Fontname " + fnt.fontname + " unknown";
   sys.exit(0);

fontnames = libertine.fonts[fnt.fontname];

fnt.copyright = "Linux Libertine by Philipp H. Poll,\nOpen Font under Terms of following Free Software Licenses:\nGPL (General Public License) with font-exception and OFL (Open Font License).\nCreated with FontForge (http://fontforge.sf.net)\nSept 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011";
fnt.version = version;
filename = fontnames["filename"];
fnt.familyname = fontnames["familyname"];
fnt.fullname = fontnames["fullname"];
fnt.weight = fontnames["weight"];
style = fontnames["style"];
fnt.appendSFNTName("English (US)", "SubFamily", style)

fnt.selection.all()
for layer in fnt.layers:
    fnt.layers[layer].is_quadratic = False

# removeBackground()
fnt.activeLayer = "Back";
fnt.clear();
fnt.activeLayer = "Fore";

fnt.unlinkReferences()
fnt.removeOverlap()
fnt.round(10)
fnt.em = 1000

outname = sys.argv[2] + "/" + filename + ".sfd"
fnt.save(outname)
print "###    saved as " + outname

# namelist
#if fnt.fontname == "LinLibertineO" or fnt.fontname == "LinBiolinumO":
#    outname = sys.argv[2] + "/" + fnt.fontname + ".nam"
#    print "###    create " + outname
#    fnt.saveNamelist(outname)

