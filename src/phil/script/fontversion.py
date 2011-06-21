#!/usr/bin/env fontforge
# -*- coding: utf-8 -*-
#
# erzeugt eine Datei mit der Fontversion 
#
# $1 sfd-file
# $2 output-dir
#
# $Id: copysfd.py 143 2011-01-08 17:19:59Z mgn $
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

filename = sys.argv[2] + "/fontversion.mk"
out = open(filename, "w")
out.write("FONTVERSION=" + fnt.version + "\n")
out.close()


