#!/usr/bin/env fontforge
# -*- coding: utf-8 -*-
#
# gibt alle tex-Namen aus.
#
# $1 sfd-dir
#
# $Id: sfd2alias.py 83 2011-05-28 18:03:25Z michael $
#
# Michael Niedermair m.g.n@gmx.de
#
import fontforge
import glob
import libertine
import os
import sys

if len(sys.argv) < 2:
    sys.exit(sys.argv[0] + ' <sfd-dir>')
if not os.path.isdir(sys.argv[1]):
    sys.exit(sys.argv[1] + ' is not a valid dir!')

dateiliste = glob.glob(sys.argv[1] + '/*.sfd');

for file in dateiliste:
	# print "### " + file;
	fnt = fontforge.open(file);

	if libertine.fonts.has_key(fnt.fontname) == False:
		print "###    unknown " + file;
		continue;

	fontnames = libertine.fonts[fnt.fontname];

	if fontnames.has_key("texfilename") == True:
		x = len(sys.argv[1]) + 1
		fn = file[x:]
		print fn + "," + fontnames["texfilename"] + ".sfd";


