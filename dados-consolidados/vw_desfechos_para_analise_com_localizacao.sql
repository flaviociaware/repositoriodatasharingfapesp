CREATE VIEW vw_desfechos_para_analise AS
SELECT y.id_paciente, y.ic_sexo, y.aa_nascimento, y.localizacao
, (extract(year from max_dt_desfecho)::integer - aa_nascimento::integer) idade
, y.max_dt_desfecho
, y.qtd_desfechos
, y.qtd_desfechos_inalterado
, y.qtd_desfechos_melhorado
, y.qtd_desfechos_curado
, y.qtd_desfechos_alta_internacao
, y.qtd_desfechos_pronto_atendimento
, y.qtd_desfechos_desistencia
, y.qtd_desfechos_transfer
, y.qtd_desfechos_neonatal
, y.qtd_desfechos_alta_administrativa
, y.qtd_desfechos_ambulatorio
, y.qtd_desfechos_assistencia_domiciliar
, y.qtd_desfechos_obito
FROM (
SELECT p.id_paciente, p.ic_sexo, p.aa_nascimento, p.cd_pais||' | '||p.cd_uf||' | '||p.cd_municipio localizacao
, (select sum(x1.qtd) 
   from ((select count(*) qtd from bpsp_desfecho_01 d WHERE p.id_paciente::text = d.id_paciente::text)
          union all
         (select count(*) qtd from hsl_desfechos_4 d WHERE p.id_paciente::text = d.id_paciente::text)) x1) qtd_desfechos
, (select max(x1.dt_desfecho_norm) 
   from ((select max(to_date(
                CASE
                    WHEN d.dt_desfecho::text !~~ '%DD%'::text THEN d.dt_desfecho
                    ELSE d.dt_atendimento
                END::text, 'dd/mm/yyyy'::text)) dt_desfecho_norm from bpsp_desfecho_01 d WHERE p.id_paciente::text = d.id_paciente::text  )
          union all
         (select max(to_date(
                CASE
                    WHEN d.dt_desfecho::text !~~ '%DD%'::text THEN d.dt_desfecho
                    ELSE d.dt_atendimento
                END::text, 'dd/mm/yyyy'::text)) dt_desfecho_norm from hsl_desfechos_4 d WHERE p.id_paciente::text = d.id_paciente::text  )) x1) max_dt_desfecho
, (select sum(x1.qtd) 
   from ((select count(*) qtd from bpsp_desfecho_01 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%obito%' )
          union all
         (select count(*) qtd from hsl_desfechos_4 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%obito%' )) x1) qtd_desfechos_obito
, (select sum(x1.qtd) 
   from ((select count(*) qtd from bpsp_desfecho_01 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%melhorado%' )
          union all
         (select count(*) qtd from hsl_desfechos_4 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%melhorado%' )) x1) qtd_desfechos_melhorado
, (select sum(x1.qtd) 
   from ((select count(*) qtd from bpsp_desfecho_01 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%curado%' )
          union all
         (select count(*) qtd from hsl_desfechos_4 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%curado%' )) x1) qtd_desfechos_curado
, (select sum(x1.qtd) 
   from ((select count(*) qtd from bpsp_desfecho_01 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%alta%interna%' )
          union all
         (select count(*) qtd from hsl_desfechos_4 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%alta%interna%' )) x1) qtd_desfechos_alta_internacao
, (select sum(x1.qtd) 
   from ((select count(*) qtd from bpsp_desfecho_01 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%pronto%atendimento%' )
          union all
         (select count(*) qtd from hsl_desfechos_4 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%pronto%atendimento%' )) x1) qtd_desfechos_pronto_atendimento
, (select sum(x1.qtd) 
   from ((select count(*) qtd from bpsp_desfecho_01 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho in ('Alta a pedido', 'Alta por Outros Motivos', 'Alta por abandono', 'Alta por outros motivos/ Desistencia', 'Alta por Outros Motivos', 'Desistência do atendimento','Evadiu-se') )
          union all
         (select count(*) qtd from hsl_desfechos_4 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho in ('Alta a pedido', 'Alta por Outros Motivos', 'Alta por abandono', 'Alta por outros motivos/ Desistencia', 'Alta por Outros Motivos', 'Desistência do atendimento','Evadiu-se') )) x1) qtd_desfechos_desistencia
, (select sum(x1.qtd) 
   from ((select count(*) qtd from bpsp_desfecho_01 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho in ('Alta Administrativa', 'Alta Cancelamento Atendimento') )
          union all
         (select count(*) qtd from hsl_desfechos_4 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho in ('Alta Administrativa', 'Alta Cancelamento Atendimento') )) x1) qtd_desfechos_alta_administrativa
, (select sum(x1.qtd) 
   from ((select count(*) qtd from bpsp_desfecho_01 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%transfer%' )
          union all
         (select count(*) qtd from hsl_desfechos_4 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%transfer%' )) x1) qtd_desfechos_transfer
, (select sum(x1.qtd) 
   from ((select count(*) qtd from bpsp_desfecho_01 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%neonatal%' )
          union all
         (select count(*) qtd from hsl_desfechos_4 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%neonatal%' )) x1) qtd_desfechos_neonatal
, (select sum(x1.qtd) 
   from ((select count(*) qtd from bpsp_desfecho_01 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%ambulatori%' )
          union all
         (select count(*) qtd from hsl_desfechos_4 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%ambulatori%' )) x1) qtd_desfechos_ambulatorio
, (select sum(x1.qtd) 
   from ((select count(*) qtd from bpsp_desfecho_01 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%inalterado%' )
          union all
         (select count(*) qtd from hsl_desfechos_4 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%inalterado%' )) x1) qtd_desfechos_inalterado
, (select sum(x1.qtd) 
   from ((select count(*) qtd from bpsp_desfecho_01 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%domiciliar%' )
          union all
         (select count(*) qtd from hsl_desfechos_4 d WHERE p.id_paciente::text = d.id_paciente::text AND d.de_desfecho ilike '%domiciliar%' )) x1) qtd_desfechos_assistencia_domiciliar
		 
FROM pacientes p
WHERE (select sum(x1.qtd) 
   from ((select count(*) qtd from bpsp_desfecho_01 d WHERE p.id_paciente::text = d.id_paciente::text)
          union all
         (select count(*) qtd from hsl_desfechos_4 d WHERE p.id_paciente::text = d.id_paciente::text)) x1) > 0
--LIMIT 100
) Y

/*

SELECT * FROM public.vw_totais_pacientes_desfechos_obitos ORDER BY DSC

*/
