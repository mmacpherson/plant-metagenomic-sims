#!/bin/bash

KRAKEN_DIR=${HOME}/kraken-db-pivo
SRA_DIR=${HOME}/sras/assemblies

for asm in $(ls ${SRA_DIR}/*.contigs.fa)
do
    basm=$(basename ${asm})
    sraname=${basm%%.*}
    outfile=${sraname}.result
    if [ -e $outfile ]
    then
	echo "Skipping ${sraname}..."
    else
	echo "Processing ${sraname}..."
	kraken --preload --threads 63 --db ${KRAKEN_DIR} ${asm} > $outfile
    fi
done