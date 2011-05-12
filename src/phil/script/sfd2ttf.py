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

if fontnames.has_key("ttffamilyname") == False:
   print "### Fontname " + fnt.fontname + " no ttf version";
   sys.exit(0);

fnt.fontname = fontnames["ttffontname"];
fnt.familyname = fontnames["ttffamilyname"];
fnt.fullname = fontnames["ttffullname"];
fnt.weight = fontnames["ttfweight"];

fnt.selection.all()
for layer in fnt.layers:
    fnt.layers[layer].is_quadratic = True

fnt.em = 2048
fnt.round(1)
fnt.autoInstr()

basename = os.path.basename(sys.argv[1])
filename = re.sub('(?P<name>.*)\.sfd', '\g<name>', basename)
outname = sys.argv[2] + "/" + filename + ".ttf"
print "###    generate " + outname
#fnt.generate(outname, flags='old-kern')
fnt.generate(outname)

