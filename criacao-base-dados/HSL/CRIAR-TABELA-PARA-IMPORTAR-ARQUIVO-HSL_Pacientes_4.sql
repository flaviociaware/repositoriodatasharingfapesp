CREATE TABLE HSL_Pacientes_4 (
  ID_PACIENTE VARCHAR(60) NOT NULL PRIMARY KEY
, IC_SEXO VARCHAR(1) 
, AA_NASCIMENTO VARCHAR(4)
, CD_PAIS VARCHAR(2)
, CD_UF VARCHAR(2)
, CD_MUNICIPIO VARCHAR(255)
, CD_CEPREDUZIDO VARCHAR(8)
);


\copy HSL_Pacientes_4 
FROM '/Users/fbarbosa/git/repositoriodatasharingfapesp/arquivos-fonte/HSL_Junho2021-2020-06-30/HSL_Pacientes_4.csv' 
csv header delimiter '|'



\copy HSL_Pacientes_4 FROM '/Users/fbarbosa/Downloads/HSL_Junho2021/HSL_Pacientes_4.csv' csv header delimiter '|'