#!/bin/sh

PLANT_GENOMES_DB=$1
TARGET_KRAKEN_DB=$2
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

for fn in $(find $PLANT_GENOMES_DB -name "*.fna.gz")
do
    asm_report=${fn/genomic.fna.gz/assembly_report.txt}
    if [ ! -e $asm_report ]
    then
	echo "Missing assembly report for $fn"
	continue
    fi
    bfn=$(basename $fn)
    uncompressed=/tmp/${bfn/.gz/}
    cat $fn | gunzip > $uncompressed
    taxid=$(grep "^# Taxid:" ${asm_report} | cut -d: -f2 | tr -d "[:space:]")
    sed -i "s/^>/>kraken:taxid|${taxid} /" $uncompressed
    kraken-build --add-to-library $uncompressed --db ${TARGET_KRAKEN_DB}
    rm -f $uncompressed
done
