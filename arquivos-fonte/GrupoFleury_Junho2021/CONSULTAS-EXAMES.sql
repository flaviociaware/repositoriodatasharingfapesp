-- TOTAL DE LINHAS
-- 5339293 LINHAS DE DADOS IMPORTADAS
-- 6329104 LINHAS DE DADOS NO ARQUIVO
SELECT COUNT(*) qtd_n FROM bpsp_exames_01;

-- TOTAL DE LINHAS A SEREM CONSIDERADAS
-- REMOVENDO REGIAO "MMMM"
-- REMOVENDO AA_NASCIMENTO IGUAL "AAAA" 
-- REMOVENDO AA_NASCIMENTO IGUAL "YYYY"
-- TOTAL 1267753 LINHAS DE DADOS VÁLIDOS
select count(*) 
from bpsp_exames_01 e
join bpsp_pacientes_01 p ON (e.id_paciente = p.id_paciente)
where not cd_municipio ilike '%MMMM%'
  and AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' );

-- QUANTIDADE DE EXAMES POR ANO
-- 2019=180
-- 2020=186039
-- 2021=20870
SELECT 
  SUBSTRING(E.DT_COLETA,7,4) AS ANO,
  COUNT(*) QTD_REGISTROS,
  COUNT(DISTINCT E.DE_EXAME || '*' || E.ID_ATENDIMENTO) QTD 
FROM bpsp_exames_01 E
JOIN bpsp_pacientes_01 P ON (e.id_paciente = p.id_paciente)
WHERE not P.cd_municipio ilike '%MMMM%'
  AND P.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
GROUP BY ANO
ORDER BY QTD DESC;

-- 
-- 593 LINHAS
-- HEMOGRAMA COM 38 ANALITOS
SELECT 
  DE_EXAME,
  COUNT(DISTINCT E.ID_ATENDIMENTO ) QTD_EXAMES,
  COUNT(DISTINCT E.DE_ANALITO) QTD_ANALITOS_DO_EXAME,
  COUNT(*) QTD
FROM bpsp_exames_01 E
JOIN bpsp_pacientes_01 P ON (e.id_paciente = p.id_paciente)
WHERE not P.cd_municipio ilike '%MMMM%'
  AND P.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
GROUP BY DE_EXAME
ORDER BY QTD DESC;