# Notes and pseudo or real code on how to build the kraken db from
# scratch.

# generate list of all available plant genomes from NCBI
python ~/plant-metagenomic-sims/generate_plant_genomes_download_script.py > plant-genome-download.sh 2> plant-genome-download.log

# download genomes and supporting files
source plant-genome-download.sh

# interactively, verify integrity of plant genomes
python ~/plant-metagenomic-sims/verify_plant_genomes.py

# add dl'ed plant genomes to kraken db
source ~/plant-metagenomic-sims/build_kraken_plant_db.sh ~/plant-genomes/ ~/kraken-db/

# which SRAs do we want in the DB?
# we take the largest available SRA from each species
sqlite3 sample-db/sra.db < which-sras.sql > reference_sra_runs

# ensure the SRA data are present with prefetch or aspera client
for sra in $(cat reference_sra_runs )
do
    ~/src/sratoolkit.2.4.3-centos_linux64/bin/prefetch $sra
done

# ~/.aspera/connect/bin/ascp -T -l 23000 -k2 -i /home/macpherson/.aspera/connect/etc/asperaweb_id_dsa.openssh --user anonftp --host ftp.ncbi.nlm.nih.gov --mode recv --file-list ~/plant-metagenomic-sims/aartem_and_atrid.txt ~/ncbi/public/sra/
