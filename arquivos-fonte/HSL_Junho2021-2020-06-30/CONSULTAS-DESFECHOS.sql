-- TOTAL DE LINHAS
-- 89937 LINHAS DE DADOS IMPORTADAS
-- 89937 LINHAS DE DADOS NO ARQUIVO
SELECT COUNT(*) qtd_n FROM HSL_Desfechos_4;

-- TOTAL DE LINHAS A SEREM CONSIDERADAS
-- REMOVENDO REGIAO "MMMM"
-- REMOVENDO AA_NASCIMENTO IGUAL "AAAA" 
-- REMOVENDO AA_NASCIMENTO IGUAL "YYYY"
-- TOTAL 68159 LINHAS DE DADOS VÁLIDOS
select count(d.ID_PACIENTE) 
from HSL_Desfechos_4 d  
join HSL_Pacientes_4 p ON (d.id_paciente = p.id_paciente)
where not cd_municipio ilike '%MMMM%'
  and AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
  and EXISTS (SELECT 1 FROM HSL_Exames_4 e4 WHERE e4.id_paciente=d.id_paciente);

-- QUANTIDADE DE EXAMES POR ANO
-- 2020=41436
-- 2021=26723
SELECT 
  (CASE WHEN (D.DT_DESFECHO = 'DDMMAA') THEN SUBSTRING(D.DT_ATENDIMENTO,7,4) ELSE SUBSTRING(D.DT_DESFECHO,7,4) END) AS ANO,
  COUNT(*) QTD_REGISTROS,
  COUNT(DISTINCT D.DE_DESFECHO || '*' || D.ID_ATENDIMENTO) QTD 
FROM HSL_Desfechos_4 D
JOIN HSL_Pacientes_4 P ON (D.id_paciente = p.id_paciente)
WHERE not P.cd_municipio ilike '%MMMM%'
  AND P.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
  and EXISTS (SELECT 1 FROM HSL_Exames_4 e4 WHERE e4.id_paciente=d.id_paciente)
GROUP BY ANO
ORDER BY QTD DESC;

-- 
-- 10 LINHAS (DESFECHOS)
SELECT 
  DE_DESFECHO,
  COUNT(DISTINCT D.ID_PACIENTE || '*' || D.DT_DESFECHO ) QTD,
  COUNT(*) QTD_REGISTROS
FROM HSL_Desfechos_4 D
JOIN HSL_Pacientes_4 P ON (D.id_paciente = p.id_paciente)
WHERE not P.cd_municipio ilike '%MMMM%'
  AND P.AA_NASCIMENTO NOT IN ( 'AAAA', 'YYYY' )
GROUP BY DE_DESFECHO
ORDER BY QTD DESC;

-- QTD DE DESFECHOS POR TIPO
SELECT D.DE_DESFECHO
, COUNT(D.ID_PACIENTE || '*' || D.DT_DESFECHO) QTD 
, COUNT(*) QTD_REGISTROS
FROM HSL_DESFECHOS_4 D
GROUP BY D.DE_DESFECHO 
ORDER BY QTD DESC;

-- QTD DE DESFECHOS DESCONSIDERANDO OUTROS TIPOS
SELECT D.DE_DESFECHO
, COUNT(D.ID_PACIENTE || '*' || D.DT_DESFECHO) QTD 
, COUNT(*) QTD_REGISTROS
FROM HSL_DESFECHOS_4 D
WHERE D.DE_DESFECHO NOT IN ('Desistência do atendimento'
					   , 'Transferência Inter-Hospitalar Externa - Serviço de Ambulância'
					   , 'Assistência Domiciliar'
					   , 'Transferência Inter-Hospitalar Externa - Transporte Próprio' )
GROUP BY D.DE_DESFECHO 
ORDER BY QTD DESC;


-- QTD DE DESFECHOS POR ALTA/OBITO
SELECT 
  SUM((CASE WHEN (X.DE_DESFECHO ILIKE 'Alta%') THEN X.QTD ELSE 0 END)) QTD_ALTAS,
  SUM((CASE WHEN (X.DE_DESFECHO ILIKE 'Óbito%') THEN X.QTD ELSE 0 END)) QTD_OBITOS
FROM (
SELECT D.DE_DESFECHO
, COUNT(D.ID_PACIENTE || '*' || D.DT_DESFECHO) QTD 
, COUNT(*) QTD_REGISTROS
FROM HSL_DESFECHOS_4 D
WHERE D.DE_DESFECHO NOT IN ('Desistência do atendimento'
					   , 'Transferência Inter-Hospitalar Externa - Serviço de Ambulância'
					   , 'Assistência Domiciliar'
					   , 'Transferência Inter-Hospitalar Externa - Transporte Próprio' )
GROUP BY D.DE_DESFECHO 
) X;