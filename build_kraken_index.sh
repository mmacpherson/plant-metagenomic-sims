#!/bin/sh

TARGET_KRAKEN_DB=$1
KMER_LEN=19
MIN_LEN=11


kraken-build --build \
    --db ${TARGET_KRAKEN_DB} \
    --threads 63 \
    --kmer-len ${KMER_LEN} \
    --minimizer-len ${MIN_LEN} \
    --jellyfish-hash-size 12000M \
    --max-db-size 100

