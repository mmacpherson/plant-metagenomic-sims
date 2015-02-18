#!/bin/sh

sra_id=$1
sqlite3 ${HOME}/plant-metagenomic-sims/sample-db/sra.db "select p.taxid from sra_runs s join projects p on s.BioProject_s=p.project_id where Run_s = \"$1\""
