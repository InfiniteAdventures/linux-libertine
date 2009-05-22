#!/bin/bash
export PATH=/usr/local/texlive/2008/bin/i386-linux:$PATH 
export MANPATH=/usr/local/texlive/2008/texmf/doc/man:$MANPATH 
export INFOPATH=/usr/local/texlive/2008/texmf/doc/info:$INFOPATH

export TOPDIR=`pwd`
export PATH=${TOPDIR}/bin:$PATH
export TEXINPUTS=.:images/:$TEXINPUTS
export TEXMFHOME=texmf:$TEXMFHOME
