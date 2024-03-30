-- TOTAL DE LINHAS
-- 3751 LINHAS DE DADOS IMPORTADAS
-- 3751 LINHAS DE DADOS NO ARQUIVO
SELECT COUNT(*) qtd_n FROM HC_PACIENTES_1;

-- TOTAL DE LINHAS A SEREM CONSIDERADAS
-- REMOVENDO REGIAO "MMMM"
-- REMOVENDO AA_NASCIMENTO IGUAL "AAAA" 
-- TOTAL 2148 LINHAS DE DADOS VÁLIDOS
SELECT COUNT(*) qtd_n 
FROM HC_PACIENTES_1
where not cd_municipio ilike '%MMMM%'
  and AA_NASCIMENTO <> 'AAAA';
  

-- AGRUPAMENTO POR REGIAO
select cd_pais, cd_uf, cd_municipio, count(*) qtd 
from HC_PACIENTES_1 
group by cd_pais, cd_uf, cd_municipio order by qtd desc;

-- AGRUPAMENTO POR REGIAO DESCONSIDERANDO CD_MUNICIPIO QUE CONTEM 'MMMM' E AA_NASCIMENTO <> 'AAAA'
select cd_pais, cd_uf, cd_municipio, count(*) qtd 
from HC_PACIENTES_1 
where not cd_municipio ilike '%MMMM%'
  and AA_NASCIMENTO <> 'AAAA'
group by cd_pais, cd_uf, cd_municipio order by qtd desc;


-- AGRUPAMENTO POR GENERO
select ic_sexo, count(*) qtd 
from HC_PACIENTES_1 
group by ic_sexo order by qtd desc;

-- AGRUPAMENTO POR GENERO DESCONSIDERANDO CD_MUNICIPIO QUE CONTEM 'MMMM' E AA_NASCIMENTO <> 'AAAA'
select ic_sexo, count(*) qtd 
from HC_PACIENTES_1 
where not cd_municipio ilike '%MMMM%'
  and AA_NASCIMENTO <> 'AAAA'
group by ic_sexo order by qtd desc;

-- AGRUPAMENTO POR ANO DE NASCIMENTO
select aa_nascimento, count(*) qtd 
from HC_PACIENTES_1 
group by aa_nascimento order by qtd desc;

-- AGRUPAMENTO POR ANO DE NASCIMENTO DESCONSIDERANDO CD_MUNICIPIO QUE CONTEM 'MMMM' E AA_NASCIMENTO <> 'AAAA'
select aa_nascimento, count(*) qtd 
from HC_PACIENTES_1 
where not cd_municipio ilike '%MMMM%'
  and AA_NASCIMENTO <> 'AAAA'
group by aa_nascimento order by qtd desc;
