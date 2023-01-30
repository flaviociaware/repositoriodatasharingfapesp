CREATE TABLE EINSTEIN_Pacientes_2 (
  ID_PACIENTE VARCHAR(60) NOT NULL PRIMARY KEY
, IC_SEXO VARCHAR(1) 
, AA_NASCIMENTO VARCHAR(4)
, CD_UF VARCHAR(2)
, CD_MUNICIPIO VARCHAR(255)
, CD_CEPREDUZIDO VARCHAR(8)
, CD_PAIS VARCHAR(2)

);

--drop table EINSTEIN_Pacientes_2;
--13d016bccfdd1b92039607f025f9dd87a03c3bcb|M|1961|SP|SAO PAULO|CCCC|BR

-- https://stackoverflow.com/questions/2987433/how-to-import-csv-file-data-into-a-postgresql-table
-- COPY zip_codes FROM '/path/to/csv/ZIP_CODES.txt' WITH (FORMAT csv);
COPY EINSTEIN_Pacientes_2 
FROM '/Users/fbarbosa/git/repositoriodatasharingfapesp/arquivos-fonte/EINSTEIN-Agosto-2020-06-30/EINSTEIN_Pacientes_2.csv' 
WITH  (FORMAT CSV,
    DELIMITER '|',
    HEADER TRUE);
	
