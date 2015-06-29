#!/bin/sh

SRA_PATH=${HOME}/sras
KG_BIN=${HOME}/src/kmergenie-1.6982/kmergenie

where=$(pwd)
cd $SRA_PATH
for fqfile in $(ls ${SRA_PATH}/fastq/*.fastq.gz)
do
    fqbase=$(basename $fqfile)
    kmerdir=kmergenie-runs/${fqbase/.fastq.gz/.kmergenie}
    mkdir -p $kmerdir
    cd $kmerdir
    # $KG_BIN --diploid -t 63 $fqfile
    $KG_BIN -t 63 $fqfile
    cd $SRA_PATH
done
cd $where
