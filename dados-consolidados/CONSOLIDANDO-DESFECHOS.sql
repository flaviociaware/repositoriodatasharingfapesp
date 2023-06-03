DROP VIEW vw_totais_pacientes_desfechos_obitos;
CREATE OR REPLACE VIEW public.vw_totais_pacientes_desfechos_obitos
 AS
SELECT 1 AS ord,
    'Pacientes'::text AS dsc,
    count(DISTINCT x1.id_paciente) AS qtd_pacientes,
    count(*) AS qtd,
    min(x1.dt_atendimento) AS min_dt_atendimento,
    max(x1.dt_atendimento) AS max_dt_atendimento,
	min((CASE WHEN (x1.dt_desfecho::TEXT = 'DDMMAA') THEN '2021-01-01' ELSE X1.DT_DESFECHO END)) AS min_dt_desfecho,
    max((CASE WHEN (x1.dt_desfecho::TEXT = 'DDMMAA') THEN '2021-01-01' ELSE X1.DT_DESFECHO END)) AS max_dt_desfecho
FROM (
   SELECT p.id_paciente, d.dt_atendimento, d.dt_desfecho
   FROM pacientes p
   JOIN hsl_desfechos_4 d ON p.id_paciente::text = d.id_paciente::text
   UNION ALL
   SELECT p.id_paciente, d.dt_atendimento, d.dt_desfecho
   FROM pacientes p
   JOIN bpsp_desfecho_01 d ON p.id_paciente::text = d.id_paciente::text
) x1
UNION
 SELECT 2 AS ord,
    'Óbitos'::text AS dsc,
    count(DISTINCT X2.id_paciente) AS qtd_pacientes,
    count(*) AS qtd,
    min(X2.dt_atendimento) AS min_dt_atendimento,
    max(X2.dt_atendimento) AS max_dt_atendimento,
	min((CASE WHEN (x2.dt_desfecho::TEXT = 'DDMMAA') THEN '2021-01-01' ELSE X2.DT_DESFECHO END)) AS min_dt_desfecho,
    max((CASE WHEN (x2.dt_desfecho::TEXT = 'DDMMAA') THEN '2021-01-01' ELSE X2.DT_DESFECHO END)) AS max_dt_desfecho
 FROM (
   SELECT p.id_paciente, d.dt_atendimento, d.de_desfecho, d.dt_desfecho
   FROM pacientes p
   JOIN hsl_desfechos_4 d ON p.id_paciente::text = d.id_paciente::text
   UNION ALL
   SELECT p.id_paciente, d.dt_atendimento, d.de_desfecho, d.dt_desfecho
   FROM pacientes p
   JOIN bpsp_desfecho_01 d ON p.id_paciente::text = d.id_paciente::text
 ) X2
  WHERE (X2.de_desfecho ILIKE 'Óbito%') OR (X2.de_desfecho ILIKE'Obito%' )
UNION
 SELECT 3 AS ord,
    X3.de_desfecho AS dsc,
    count(DISTINCT X3.id_paciente) AS qtd_pacientes,
    count(*) AS qtd,
    min(X3.dt_atendimento) AS min_dt_atendimento,
    max(X3.dt_atendimento) AS max_dt_atendimento,
	min((CASE WHEN (x3.dt_desfecho::TEXT = 'DDMMAA') THEN '2021-01-01' ELSE X3.DT_DESFECHO END)) AS min_dt_desfecho,
    max((CASE WHEN (x3.dt_desfecho::TEXT = 'DDMMAA') THEN '2021-01-01' ELSE X3.DT_DESFECHO END)) AS max_dt_desfecho
   FROM (
	   SELECT p.id_paciente, d.dt_atendimento, d.de_desfecho, d.dt_desfecho
	   FROM pacientes p
	   JOIN hsl_desfechos_4 d ON p.id_paciente::text = d.id_paciente::text
	   UNION ALL
	   SELECT p.id_paciente, d.dt_atendimento, d.de_desfecho, d.dt_desfecho
	   FROM pacientes p
	   JOIN bpsp_desfecho_01 d ON p.id_paciente::text = d.id_paciente::text
   ) X3
  GROUP BY X3.de_desfecho
ORDER BY 1;

ALTER TABLE public.vw_totais_pacientes_desfechos_obitos
    OWNER TO postgres;
	
/*
select * from public.vw_totais_pacientes_desfechos_obitos order by ord;


 SELECT d.de_desfecho, COUNT(*) QTD, MIN(D.DT_ATENDIMENTO)
	   FROM pacientes p
	   JOIN bpsp_desfecho_01 d ON p.id_paciente::text = d.id_paciente::text
	   GROUP BY d.de_desfecho
	   ORDER BY QTD DESC;
	   
	   
SELECT D.* FROM bpsp_desfecho_01 D ORDER BY D.DT_ATENDIMENTO;
SELECT D.* FROM HSL_desfechoS_4 D ORDER BY D.DT_ATENDIMENTO;
*/