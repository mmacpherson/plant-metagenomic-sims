#!/bin/sh

MINIA_BIN=${HOME}/src/minia-2.0.3-Linux/bin/minia
KG_SCRIPT=${HOME}/plant-metagenomic-sims/grab_kmergenie_winner.py

SRA_PATH=${HOME}/sras
FASTQ_PATH=${SRA_PATH}/fastq2
KG_PATH=${SRA_PATH}/kmergenie-runs
MINIA_PATH=${SRA_PATH}/assemblies

where=$(pwd)
# cd $FASTQ_PATH
for fqfile in $(ls ${FASTQ_PATH}/*.fastq.gz)
do
    fqbase=$(basename $fqfile)
    kmerdir=${KG_PATH}/${fqbase/.fastq.gz/.kmergenie}
    fq=${fqbase/.fastq.gz/}
    read -a kgresults <<< $(python $KG_SCRIPT $kmerdir/histograms.dat)
    KMERSIZE=${kgresults[0]}
    CUTOFF=${kgresults[1]}
    outfile=${MINIA_PATH}/${fq}.minia_assembly_k${KMERSIZE}_m${CUTOFF}
    $MINIA_BIN -nb-cores 8 -kmer-size $KMERSIZE -abundance-min $CUTOFF -in $fqfile -out $outfile &
    cd $FASTQ_PATH
done
cd $where


