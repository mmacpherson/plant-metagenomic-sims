#!/bin/sh

SRA_PATH=${HOME}/ncbi/public/sra
FASTQ_BIN=${HOME}/src/sratoolkit.2.4.3-centos_linux64/bin/fastq-dump

for srafile in $(ls ${SRA_PATH}/*.sra)
do
    srabase=$(basename $srafile)
    fastq=${srabase/sra/fastq}
    if [[ -e $fastq ]]
    then
	echo "Skipping $fastq"
	continue
    fi
    echo "Converting $fastq"
    $FASTQ_BIN --gzip $srafile
done
