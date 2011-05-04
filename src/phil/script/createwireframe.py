#!/usr/bin/env fontforge
# -*- coding: utf-8 -*-
#
# erstellt die outline Version des Libertine-Font
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
version = fnt.version

if libertine.fonts.has_key(fnt.fontname) == False:
   print "### Fontname " + fnt.fontname + " unknown";
   sys.exit(0);

fontnames = libertine.fonts[fnt.fontname];

if fontnames.has_key("wirefilename") == False:
   print "### Fontname " + fnt.fontname + " no wireframe";
   sys.exit(0);

fnt.close();

filename = fontnames["wirefilename"];
fontname = fontnames["wirefontname"];
familyname = fontnames["wirefamilyname"];
fullname = fontnames["wirefullname"];
weight = fontnames["wireweight"];
style = fontnames["wirestyle"];
# fnt.appendSFNTName("English (US)", "SubFamily", style)

# $1 sfd-file
# $2 out-dir
# $3 filename
# $4 fontname
# $5 familyname
# $6 fullname
# $7 weight
cmd = 'fontforge -script script/createWireframe.pe ' \
	+ sys.argv[1] + ' ' \
	+ sys.argv[2] + ' ' \
	+ filename + ' ' \
	+ '"' + fontname + '" ' \
	+ '"' + familyname + '" ' \
	+ '"' + fullname + '" ' \
	+ '"' + weight + '" ' \
	+ '"' + version + '"'
# + '" &'

print "### system: " + cmd
os.system(cmd)
