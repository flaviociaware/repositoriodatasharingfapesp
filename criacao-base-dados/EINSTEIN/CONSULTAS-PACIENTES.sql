-- TOTAL DE LINHAS
-- 79863 LINHAS DE DADOS IMPORTADAS
-- 79863 LINHAS DE DADOS NO ARQUIVO
SELECT COUNT(*) qtd_n FROM EINSTEIN_Pacientes_2;

-- TOTAL DE LINHAS A SEREM CONSIDERADAS
-- REMOVENDO REGIAO "MMMM"
-- REMOVENDO AA_NASCIMENTO IGUAL "AAAA" 
-- TOTAL 71607 LINHAS DE DADOS VÁLIDOS
SELECT COUNT(*) qtd_n 
FROM EINSTEIN_Pacientes_2
where not cd_municipio ilike '%MMMM%'
  and AA_NASCIMENTO <> 'AAAA';
  

-- AGRUPAMENTO POR REGIAO
select cd_pais, cd_uf, cd_municipio, count(*) qtd 
from EINSTEIN_Pacientes_2 
group by cd_pais, cd_uf, cd_municipio order by qtd desc;

-- AGRUPAMENTO POR REGIAO DESCONSIDERANDO CD_MUNICIPIO QUE CONTEM 'MMMM' E AA_NASCIMENTO <> 'AAAA'
select cd_pais, cd_uf, cd_municipio, count(*) qtd 
from EINSTEIN_Pacientes_2 
where not cd_municipio ilike '%MMMM%'
  and AA_NASCIMENTO <> 'AAAA'
group by cd_pais, cd_uf, cd_municipio order by qtd desc;


-- AGRUPAMENTO POR GENERO
select ic_sexo, count(*) qtd 
from EINSTEIN_Pacientes_2 
group by ic_sexo order by qtd desc;

-- AGRUPAMENTO POR GENERO DESCONSIDERANDO CD_MUNICIPIO QUE CONTEM 'MMMM' E AA_NASCIMENTO <> 'AAAA'
select ic_sexo, count(*) qtd 
from EINSTEIN_Pacientes_2 
where not cd_municipio ilike '%MMMM%'
  and AA_NASCIMENTO <> 'AAAA'
group by ic_sexo order by qtd desc;

-- AGRUPAMENTO POR ANO DE NASCIMENTO
select aa_nascimento, count(*) qtd 
from EINSTEIN_Pacientes_2 
group by aa_nascimento order by qtd desc;

-- AGRUPAMENTO POR ANO DE NASCIMENTO DESCONSIDERANDO CD_MUNICIPIO QUE CONTEM 'MMMM' E AA_NASCIMENTO <> 'AAAA'
select aa_nascimento, count(*) qtd 
from EINSTEIN_Pacientes_2 
where not cd_municipio ilike '%MMMM%'
  and AA_NASCIMENTO <> 'AAAA'
group by aa_nascimento order by qtd desc;
