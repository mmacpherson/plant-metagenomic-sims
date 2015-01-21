
plant-meta.db: sra_data.csv sra_data.schema
	rm -f plant-meta.db
	sqlite3 plant-meta.db < sra_data.schema
	tail -n +2 sra_data.csv > /tmp/sra_data_nohead.csv
	sqlite3 plant-meta.db -separator , ".import /tmp/sra_data_nohead.csv sra_data"
	rm -f /tmp/sra_data_nohead.csv

clean:
	rm -f plant-meta.db
