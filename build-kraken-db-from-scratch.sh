
# generate list of all available plant genomes from NCBI
python ~/plant-metagenomic-sims/generate_plant_genomes_download_script.py > plant-genome-download.sh 2> plant-genome-download.log

# download genomes and supporting files
source plant-genome-download.sh

# interactively, verify integrity of plant genomes
python ~/plant-metagenomic-sims/verify_plant_genomes.py

# add dl'ed plant genomes to kraken db
source ~/plant-metagenomic-sims/build_kraken_plant_db.sh ~/plant-genomes/ ~/kraken-db/