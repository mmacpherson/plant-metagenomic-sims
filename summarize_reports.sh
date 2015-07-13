#!/bin/sh

SB=/tmp/kraken-summary
rm -f $SB
touch $SB
for rpt in $(ls *.report)
do
    echo ${rpt/.report/} >> $SB
    echo '--------------' >> $SB
    cat $rpt | awk '$1 > 1.0 {print $0}' >> $SB
    echo '==============' >> $SB

    enscript -r $rpt -o - | ps2pdf - ${rpt/.report/.report.pdf}

done
enscript -r $SB -o - | ps2pdf - summary.pdf
