CREATE TABLE bpsp_pacientes_01 (
  ID_PACIENTE VARCHAR(60) NOT NULL PRIMARY KEY
, IC_SEXO VARCHAR(1) 
, AA_NASCIMENTO VARCHAR(4)
, CD_PAIS VARCHAR(2)	
, CD_UF VARCHAR(2)
, CD_MUNICIPIO VARCHAR(255)
, CD_CEPREDUZIDO VARCHAR(8)
);

--drop table bpsp_pacientes_01;
--13d016bccfdd1b92039607f025f9dd87a03c3bcb|M|1961|SP|SAO PAULO|CCCC|BR

-- https://stackoverflow.com/questions/2987433/how-to-import-csv-file-data-into-a-postgresql-table
-- COPY zip_codes FROM '/path/to/csv/ZIP_CODES.txt' WITH (FORMAT csv);
-- PARA MIM NÃO FUNCIONOU:
/*

COPY bpsp_pacientes_01 
FROM '/Users/fbarbosa/git/repositoriodatasharingfapesp/arquivos-fonte/BPSP-2021-04-28/bpsp_pacientes_01.csv' 
WITH  (FORMAT CSV,
    DELIMITER '|',
    HEADER TRUE);

ESTE COMANDO NÃO FUNCIONOU PORQUE OBTIVE O ERRO:
ERROR:  could not open file "/Users/fbarbosa/git/repositoriodatasharingfapesp/arquivos-fonte/BPSP-2021-04-28/bpsp_pacientes_01.csv" for reading: Permission denied
HINT:  COPY FROM instructs the PostgreSQL server process to read a file. You may want a client-side facility such as psql's \copy.

POR ISSO, USEI O COMANDO \copy E AÍ SIM, OBTIVE SUCESSO.

*/


\copy bpsp_pacientes_01 
FROM '/Users/fbarbosa/git/repositoriodatasharingfapesp/arquivos-fonte/BPSP-2021-04-28/bpsp_pacientes_01.csv' 
csv header delimiter '|'

\copy bpsp_pacientes_01 FROM '/Users/fbarbosa/Downloads/BPSP/bpsp_pacientes_01.csv' csv header delimiter '|'