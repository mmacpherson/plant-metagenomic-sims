#!/bin/bash

rundb=sra.db
metabp=bioprojects_all.txt
rm -f $metabp $rundb

echo "title|species|taxid|project_id|aid" >> $metabp
for bp in $(ls bioproject_result_??.txt)
do
    bbp=$(basename bp)
    bbp=${bp/.txt/}
    id=$(echo $bbp | cut -d_ -f3)
    #sra=$(ls sra_result_$id.csv)

    # -- extract fields from bioproject summary file
    title=$(grep "^1" $bp | cut -d" " -f2-)
    org=$(grep "^Org" $bp | cut -d" " -f2,3)
    taxid=$(grep "^Org" $bp | cut -d" " -f6 | tr -d ')' )
    accession=$(grep "^BioP" $bp | cut -d" " -f3)
    aid=$(grep "^ID:" $bp | cut -d" " -f2)

    echo "$title|$org|$taxid|$accession|$aid" >> $metabp
done
csvsql $metabp --db sqlite:///$rundb --insert --tables projects

keep='"Experiment Accession","Experiment Title","Organism Name","Instrument","Submitter","Study Accession","Study Title","Sample Accession","Sample Title","Total RUNs","Total Spots","Total Bases","Library Name","Library Strategy","Library Source","Library Selection"'
for srares in $(ls sra_result_??.csv)
do
    create=""
    if sqlite3 $rundb .schema | grep -q sra_result
    then
	create="--no-create"
    fi
    echo csvcut -c $keep $srares
    csvcut -c $keep $srares | csvsql --db sqlite:///$rundb --insert --tables sra_result $create
    echo "SRA Result Row Count:" $srares $(sqlite3 $rundb "select count(*) from sra_result")
done

keep=Assay_Type_s,AssemblyName_s,BioProject_s,BioSampleModel_s,BioSample_s,Center_Name_s,Consent_s,g1k_analysis_group_s,g1k_pop_code_s,InsertSize_l,Library_Name_s,LoadDate_s,MBases_l,MBytes_l,Platform_s,ReleaseDate_s,Run_s,Sample_Name_s,source_s,SRA_Sample_s,SRA_Study_s
for srarun in $(ls SraRunTable_??.txt)
do
    create=""
    if sqlite3 $rundb .schema | grep -q sra_runs
    then
	create="--no-create"
    fi
    csvcut -t $srarun -c $keep | csvsql --db sqlite:///$rundb --insert --tables sra_runs $create
    echo "SRA Result Run Count:" $srarun $(sqlite3 $rundb "select count(*) from sra_runs")
done

rm -f $metabp
