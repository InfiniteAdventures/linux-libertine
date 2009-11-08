export TLJAHR=2008
if [ -f 2009 ]; then TLJAHR=2009; fi
echo "using TL-$TLJAHR"
export PATH=/usr/local/fontforge/bin:$PATH
export PATH=/usr/local/texlive/$TLJAHR/bin/i386-linux:$PATH
export MANPATH=/usr/local/texlive/$TLJAHR/texmf/doc/man:$MANPATH
export INFOPATH=/usr/local/texlive/$TLJAHR/texmf/doc/info:$INFOPATH
export TOPDIR=`pwd`
export TEXINPUTS=.:$TEXINPUTS
export TEXMFHOME=$TOPDIR/texmf:$TEXMFHOME
