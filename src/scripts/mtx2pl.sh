#!/bin/sh
# $1	encfile list:  fxlmtx.txt
# $2 	afm files   :  target/pfb
# $3    output:     :  target/tex
while f=`line`
do
	encname=`basename $f .enc`
	for afm in $2/*.afm ; do 
		name=`basename $afm .afm`-$encname
        namesl=`basename $afm .afm`o-$encname
		if [ -f $3/$name.mtx ] ; then
			echo "### create $3/$name"
			tex -output-directory=$3 "\input fontinst.sty \mtxtopl{$name}{$name} \bye"
			echo "### create slanted $3/$namesl"
            tex -output-directory=$3 "\input fontinst.sty \transformfont {$namesl}{\slantfont{250}{\frommtx{$name}}} \bye"
            tex -output-directory=$3 "\input fontinst.sty \mtxtopl{$namesl}{$namesl} \bye"
		fi
	done
done < $1