#!/bin/sh

KDB=$HOME/kraken-db-pivo
KDB=/mnt/ramdisk/kraken-db-pivo

rm -f *.tr.result *.report
for r in $(ls *.result)
do
    echo $r
    kraken-translate --db $KDB $r > ${r/.result/.tr.result}
    kraken-report --db $KDB $r > ${r/.result/.report}
done

rm -f diag-hits
for tr in $(ls *.tr.result)
do
    echo $tr
    echo ${tr/.tr.result/} >> diag-hits
    cat $tr | cut -f2 | python ~/plant-metagenomic-sims/rev_string.py | sort | uniq -c | sort -rn >> diag-hits
echo "--------------"
done