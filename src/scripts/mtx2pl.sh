#!/bin/sh
# $1	encfile list:  fxlmtx.txt
# $2 	afm files   :  target/pfb
# $3    output:     :  target/tex
while f=`line`
do
	encname=`basename $f .enc`
	for afm in $2/*.afm ; do 
		name=`basename $afm .afm`-$encname
		if [ -f $3/$name.mtx ] ; then
			echo create $3/$name
			tex -output-directory=$3 "\input fontinst.sty \mtxtopl{$name}{$name} \bye"
		fi
	done
done < $1