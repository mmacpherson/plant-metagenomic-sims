#!/bin/sh

FASTQ_PATH=${HOME}/sra-fastq
MINIA_BIN=${HOME}/src/minia-2.0.1-Linux/bin/minia
KG_SCRIPT=${HOME}/plant-metagenomic-sims/grab_kmergenie_winner.py

where=$(pwd)
cd $FASTQ_PATH
for fqfile in $(ls ${FASTQ_PATH}/*.fastq.gz)
do
    fqbase=$(basename $fqfile)
    kmerdir=${fqbase/.fastq.gz/.kmergenie}
    fq=${fqbase/.fastq.gz/}
    read -a kgresults <<< $(python $KG_SCRIPT $kmerdir/histograms.dat)
    KMERSIZE=${kgresults[0]}
    CUTOFF=${kgresults[1]}
    outfile=${fq}.minia_assembly_k${KMERSIZE}_m${CUTOFF}
    $MINIA_BIN -nb-cores 63 -kmer-size $KMERSIZE -abundance-min $CUTOFF -in $fqfile -out $outfile
    cd $FASTQ_PATH
done
cd $where


