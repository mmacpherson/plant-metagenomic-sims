
plant-meta.db: sra_data.csv sra_data.schema
	rm -f plant-meta.db
	sqlite3 plant-meta.db < sra_data.schema
	sqlite3 plant-meta.db -separator , ".import sra_data.csv sra_data"


clean:
	rm -f plant-meta.db
