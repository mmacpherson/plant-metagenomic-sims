#!/bin/bash

KRAKEN_DIR=${HOME}/kraken-db-pivo
SRA_DIR=${HOME}/sras/assemblies


KRAKEN_DIR=/mnt/ramdisk/kraken-db-pivo
SRA_DIR=${HOME}/sras/mix100
SRA_DIR=$(pwd)

for asm in $(ls ${SRA_DIR}/*.fa.gz)
do
    basm=$(basename ${asm})
    sraname=${basm%%.*}
    outfile=${sraname}.result
    if [ -e $outfile ]
    then
	echo "Skipping ${sraname}..."
    else
	echo "Processing ${sraname}..."
	kraken --threads 63 --db ${KRAKEN_DIR} ${asm} > $outfile
    fi
done