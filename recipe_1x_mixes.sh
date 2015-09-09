#!/bin/sh

SF=${HOME}/plant-metagenomic-sims/sample_fasta.py

BRO_PAP=SRR1477753.fasta.gz
POA_PRA=SRR769554.fasta.gz

rm -f seqs_*_1GB.fa.*

# Mix 1 = Broussonetia papyrifera, Artemisia tridentata, Zea mays (equal proportions)
# Mix 2 = Broussonetia papyrifera, Artemisia tridentata, Zea mays, Bassia scoparia, Poa pratensis (equal proportions)
# Mix 3 = Broussonetia papyrifera, Artemisia tridentata, Zea mays​, Bassia scoparia, Poa pratensis, Populus tremuloides, Carya illinoinensis (equal proportions)
# Mix 4 = Broussonetia papyrifera, Artemisia tridentata, Zea mays​, Bassia scoparia, Poa pratensis​, Populus tremuloides, Carya illinoinensis​, Populus deltoides, Ambrosia artemisiifolia (equal proportions)
# Mix 5 = Populus tremuloides, Populus deltoides (equal proportions)
# Mix 6 = Poa pratensis, Zea mays (equal proportions)
# Mix 7 = Broussonetia papyrifera, Artemisia tridentata (equal proportions)

# -- these apply for mixes 8-11
rl=80 # poa prat has min read length
rpgb=$((10 ** 9 / rl)) # reads per GB

# Mix 8 = Broussonetia papyrifera, Poa pratensis (equal proportions)
python $SF $BRO_PAP  $((rpgb / 2)) $rl >  seqs_mix8_1GB.fa.a &
python $SF $POA_PRA  $((rpgb / 2)) $rl > seqs_mix8_1GB.fa.b & 

# Mix 9 = 10% Broussonetia papyrifera, 90% Poa pratensis
python $SF $BRO_PAP  $((rpgb * 1 / 10)) $rl >  seqs_mix9_1GB.fa.a &
python $SF $POA_PRA  $((rpgb * 9 / 10)) $rl > seqs_mix9_1GB.fa.b & 

# Mix 10 = 5% Broussonetia papyrifera, 95% Poa pratensis
python $SF $BRO_PAP  $((rpgb *  1 / 20)) $rl >  seqs_mix10_1GB.fa.a &
python $SF $POA_PRA  $((rpgb * 19 / 20)) $rl > seqs_mix10_1GB.fa.b & 

# Mix 11 = 1% Broussonetia papyrifera, 99% Poa pratensis
python $SF $BRO_PAP  $((rpgb *  1 / 100)) $rl >  seqs_mix11_1GB.fa.a &
python $SF $POA_PRA  $((rpgb * 99 / 100)) $rl > seqs_mix11_1GB.fa.b & 
