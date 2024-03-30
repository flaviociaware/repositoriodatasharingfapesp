-- TOTAL DE LINHAS
-- 39000 LINHAS DE DADOS IMPORTADAS
-- 39000 LINHAS DE DADOS NO ARQUIVO
SELECT COUNT(*) qtd_n FROM bpsp_pacientes_01;

-- TOTAL DE LINHAS A SEREM CONSIDERADAS
-- REMOVENDO REGIAO "MMMM"
-- REMOVENDO AA_NASCIMENTO IGUAL "YYYY" 
-- TOTAL 10248 LINHAS DE DADOS VÁLIDOS
SELECT COUNT(*) qtd_n 
FROM bpsp_pacientes_01
where not cd_municipio ilike '%MMMM%'
  AND AA_NASCIMENTO<>'YYYY';

-- AGRUPAMENTO POR REGIAO
select cd_pais, cd_uf, cd_municipio, count(*) qtd 
from bpsp_pacientes_01 
group by cd_pais, cd_uf, cd_municipio order by qtd desc;

-- AGRUPAMENTO POR REGIAO DESCONSIDERANDO CD_MUNICIPIO QUE CONTEM 'MMMM' E AA_NASCIMENTO<>'YYYY'
select cd_pais, cd_uf, cd_municipio, count(*) qtd 
from bpsp_pacientes_01 
where not cd_municipio ilike '%MMMM%'
  AND AA_NASCIMENTO<>'YYYY'
group by cd_pais, cd_uf, cd_municipio order by qtd desc;


-- AGRUPAMENTO POR GENERO
select ic_sexo, count(*) qtd 
from bpsp_pacientes_01 
group by ic_sexo order by qtd desc;

-- AGRUPAMENTO POR GENERO DESCONSIDERANDO CD_MUNICIPIO QUE CONTEM 'MMMM' E AA_NASCIMENTO<>'YYYY'
select ic_sexo, count(*) qtd 
from bpsp_pacientes_01 
where not cd_municipio ilike '%MMMM%'
  AND AA_NASCIMENTO<>'YYYY'
group by ic_sexo order by qtd desc;

-- AGRUPAMENTO POR ANO DE NASCIMENTO
select aa_nascimento, count(*) qtd 
from bpsp_pacientes_01 
group by aa_nascimento order by qtd desc;

-- AGRUPAMENTO POR ANO DE NASCIMENTO DESCONSIDERANDO CD_MUNICIPIO QUE CONTEM 'MMMM' E AA_NASCIMENTO<>'YYYY'
select aa_nascimento, count(*) qtd 
from bpsp_pacientes_01 
where not cd_municipio ilike '%MMMM%' 
  AND AA_NASCIMENTO<>'YYYY'
group by aa_nascimento order by qtd desc;
