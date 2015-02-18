#!/bin/sh

PLANT_GENOMES_DB=$1
TARGET_KRAKEN_DB=$2
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

for fn in $(find $PLANT_GENOMES_DB -name "*.sra")
do
    # asm_report=${fn/genomic.fna.gz/assembly_report.txt}
    # if [ ! -e $asm_report ]
    # then
    # 	echo "Missing assembly report for $fn"
    # 	continue
    # fi
    bfn=$(basename $fn)
    runid=${bfn/.sra/}
    uncompressed=/tmp/${bfn/.gz/}
    taxid=$($DIR/look_up_taxid.sh $runid)
    ~/src/sratoolkit.2.4.3-centos_linux64/bin/fastq-dump $fn --fasta -Z | sed "s/^>/>kraken:taxid|$taxid /" > $uncompressed
    kraken-build --add-to-library $uncompressed --db ${TARGET_KRAKEN_DB}
    rm -f $uncompressed
done
