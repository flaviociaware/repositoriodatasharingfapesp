-- TOTAL DE LINHAS
-- 2498650 LINHAS DE DADOS NO ARQUIVO
-- 2498650 LINHAS DE DADOS IMPORTADAS
SELECT COUNT(*) qtd_n FROM HC_EXAMES_1;

-- TOTAL DE LINHAS A SEREM CONSIDERADAS
-- REMOVENDO REGIAO "MMMM"
-- REMOVENDO AA_NASCIMENTO IGUAL "AAAA" 
-- REMOVENDO AA_NASCIMENTO IGUAL "YYYY"
-- TOTAL 1302269 LINHAS DE DADOS VÁLIDOS
select count(*) 
from HC_EXAMES_1 e
join HC_PACIENTES_1 p ON (e.id_paciente = p.id_paciente)
where not cd_municipio ilike '%MMMM%'
  and AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' );

-- QUANTIDADE DE EXAMES POR ANO
-- 2020=334347
SELECT 
  SUBSTRING(E.DT_COLETA,1,4) AS ANO,
  COUNT(*) QTD_REGISTROS,
  COUNT(DISTINCT E.DE_EXAME || '*' || E.ID_PACIENTE || '*' || E.DT_COLETA) QTD 
FROM HC_EXAMES_1 E
JOIN HC_PACIENTES_1 P ON (e.id_paciente = p.id_paciente)
WHERE not P.cd_municipio ilike '%MMMM%'
  AND P.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
GROUP BY ANO
ORDER BY QTD DESC;


-- 
-- 419 LINHAS
-- 32 ANALITOS PARA O HEMOGRAMA COMPLETO
SELECT 
  DE_EXAME,
  COUNT(DISTINCT E.ID_PACIENTE || '*' || E.DT_COLETA ) QTD_EXAMES,
  COUNT(DISTINCT E.DE_ANALITO) QTD_ANALITOS_DO_EXAME,
  COUNT(*) QTD
FROM HC_EXAMES_1 E
JOIN HC_PACIENTES_1 P ON (e.id_paciente = p.id_paciente)
WHERE not P.cd_municipio ilike '%MMMM%'
  AND P.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
GROUP BY DE_EXAME
ORDER BY QTD DESC;