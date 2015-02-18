#!/bin/sh

FASTQ_PATH=${HOME}/sra-fastq
KG_BIN=${HOME}/src/kmergenie-1.6950/kmergenie

where=$(pwd)
cd $FASTQ_PATH
for fqfile in $(ls ${FASTQ_PATH}/*.fastq.gz)
do
    fqbase=$(basename $fqfile)
    kmerdir=${fqbase/.fastq.gz/.kmergenie}
    mkdir -p $kmerdir
    cd $kmerdir
    # $KG_BIN --diploid -t 63 $fqfile
    $KG_BIN -t 63 $fqfile
    cd $FASTQ_PATH
done
cd $where
