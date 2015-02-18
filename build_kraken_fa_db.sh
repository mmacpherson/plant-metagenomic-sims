#!/bin/sh

FASTA_DB=$1
TARGET_KRAKEN_DB=$2
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

for fn in $(find $FASTA_DB -name "*.fa")
do
    bfn=$(basename $fn)
    runid=$(echo $bfn | cut -f1 -d".")
    withtaxa=/tmp/${bfn}
    taxid=$($DIR/look_up_taxid.sh $runid)
    echo $runid $withtaxa $taxid
    sed "s/^>/>kraken:taxid|$taxid /" $fn > $withtaxa
    kraken-build --add-to-library $withtaxa --db ${TARGET_KRAKEN_DB}
    rm -f $withtaxa
done
