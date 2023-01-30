-- CRIANDO TABELA PARA CONSOLIDAÇÃO DE PACIENTES (UNIFICAÇÃO)
CREATE TABLE PACIENTES
(
    ID_PACIENTE VARCHAR(60) NOT NULL PRIMARY KEY,
    IC_SEXO VARCHAR(1) ,
    AA_NASCIMENTO VARCHAR(4) ,
    CD_PAIS VARCHAR(2) ,
    CD_UF VARCHAR(2) ,
    CD_MUNICIPIO VARCHAR(255) ,
    CD_CEPREDUZIDO VARCHAR(8) ,
    TABELA_ORIGEM VARCHAR(60) ,
    DATA_CRIACAO TIMESTAMP
);


CREATE INDEX IDX_PACIENTES_1 ON PACIENTES (ID_PACIENTE);

-- ADICIONANDO REGISTROS DE PACIENTES DAS ORGANIZAÇÕES DE SAÚDE 
-- 783807 LINHAS ADICIONADAS
INSERT INTO PACIENTES (id_paciente, ic_sexo, aa_nascimento, cd_pais, cd_uf, cd_municipio, cd_cepreduzido, tabela_origem, data_criacao)
  SELECT id_paciente, ic_sexo, aa_nascimento, cd_pais, cd_uf, cd_municipio, cd_cepreduzido, 'bpsp_pacientes_01', CURRENT_TIMESTAMP 
  FROM bpsp_pacientes_01 P 
  WHERE not p.cd_municipio ilike '%MMMM%' and p.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
  UNION ALL
  SELECT id_paciente, ic_sexo, aa_nascimento, cd_pais, cd_uf, cd_municipio, cd_cepreduzido, 'einstein_pacientes_2', CURRENT_TIMESTAMP 
  FROM einstein_pacientes_2 P 
  WHERE not p.cd_municipio ilike '%MMMM%' and p.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
  UNION ALL
  SELECT id_paciente, ic_sexo, aa_nascimento, cd_pais, cd_uf, cd_municipio, cd_cepreduzido, 'hc_pacientes_1', CURRENT_TIMESTAMP 
  FROM hc_pacientes_1 P
  WHERE not p.cd_municipio ilike '%MMMM%' and p.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
  UNION ALL
  SELECT id_paciente, ic_sexo, aa_nascimento, cd_pais, cd_uf, cd_municipio, cd_cepreduzido, 'hsl_pacientes_4', CURRENT_TIMESTAMP 
  FROM hsl_pacientes_4 P 
  WHERE not p.cd_municipio ilike '%MMMM%' and p.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
  UNION ALL
  SELECT id_paciente, ic_sexo, aa_nascimento, cd_pais, cd_uf, cd_municipio, cd_cepreduzido, 'grupofleury_pacientes_4', CURRENT_TIMESTAMP 
  FROM grupofleury_pacientes_4 P 
  WHERE not p.cd_municipio ilike '%MMMM%' and p.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' );


-- CONTANDO O NÚMERO DE REGISTRO DE CADA ORGANIZAÇÃO PARA COMPARAR COM TOTAL DE PACIENTES
-- 783807 LINHAS
SELECT SUM(U.QTD) SOMA_QTD_pacientes FROM (
  SELECT COUNT(*) QTD 
  FROM bpsp_pacientes_01 P
  WHERE not p.cd_municipio ilike '%MMMM%' and p.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
  UNION ALL
  SELECT COUNT(*) QTD
  FROM einstein_pacientes_2 P 
  WHERE not p.cd_municipio ilike '%MMMM%' and p.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
  UNION ALL
  SELECT COUNT(*) QTD
  FROM hc_pacientes_1 P 
  WHERE not p.cd_municipio ilike '%MMMM%' and p.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
  UNION ALL
  SELECT COUNT(*) QTD
  FROM hsl_pacientes_4 P 
  WHERE not p.cd_municipio ilike '%MMMM%' and p.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
  UNION ALL
  SELECT COUNT(*) QTD
  FROM grupofleury_pacientes_4 P 
  WHERE not p.cd_municipio ilike '%MMMM%' and p.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
) U;


-- CONTANDO O TOTAL DE PACIENTES
-- 783807 LINHAS
select count(*) from PACIENTES;