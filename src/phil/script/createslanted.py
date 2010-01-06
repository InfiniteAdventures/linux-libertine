#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# erstellt die slanted Version des Libertine-Font
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

if libertine.fonts.has_key(fnt.fontname) == False:
   print "### Fontname " + fnt.fontname + " unknown";
   sys.exit(0);

fontnames = libertine.fonts[fnt.fontname];

angle = psMat.skew(math.radians(12))

if fontnames.has_key("slfilename") == False:
   print "### Fontname " + fnt.fontname + " not slanted";
   sys.exit(0);

filename = fontnames["slfilename"];
fnt.fontname = fontnames["slfontname"];
fnt.familyname = fontnames["slfamilyname"];
fnt.fullname = fontnames["slfullname"];
fnt.weight = fontnames["slweight"];

fnt.selection.all()
fnt.transform(angle)

outname = sys.argv[2] + "/" + filename + "-" + fnt.version + ".sfd"
fnt.save(outname)
print "###    saved as " + outname

