-- SLA Geral
SELECT  
(SUM(case when sla_attend = 'TRUE' then 1 else 0 end) * 100)/count(*) as perc
FROM VW_KPI_TICKETS 
WHERE 1=1
AND to_char(FINISH_TIME,'YYYY-MM-DD') between '2018-09-01'and '2018-09-03'

-- SLA : CSTI
SELECT  
ROUND((SUM(case when sla_attend = 'TRUE' then 1 else 0 end) * 100)/count(*),0) as perc
FROM VW_KPI_TICKETS 
WHERE 1=1
AND to_char(FINISH_TIME,'YYYY-MM-DD') between '2018-09-01'and '2018-09-03'
AND queue_finish in (SELECT id FROM queue WHERE name like 'CENTRAL DE SERVIÇO%')

-- SLA : BANCO DE DADOS
SELECT  
ROUND((SUM(case when sla_attend = 'TRUE' then 1 else 0 end) * 100)/count(*),0) as perc
FROM VW_KPI_TICKETS 
WHERE 1=1
AND to_char(FINISH_TIME,'YYYY-MM-DD') between '2018-09-01'and '2018-09-03'
AND queue_finish in (SELECT name FROM queue WHERE name like 'BANCO DE DADOS%')

-- SLA : INFRAESTRUTURA
SELECT  
ROUND((SUM(case when sla_attend = 'TRUE' then 1 else 0 end) * 100)/count(*),0) as perc
FROM VW_KPI_TICKETS 
WHERE 1=1
AND to_char(FINISH_TIME,'YYYY-MM-DD') between '2018-09-01'and '2018-09-03'
AND queue_finish in (SELECT name FROM queue WHERE name like 'INFRAESTRUTURA%')

-- SLA : SISTEMAS
SELECT  
ROUND((SUM(case when sla_attend = 'TRUE' then 1 else 0 end) * 100)/count(*),0) as perc
FROM VW_KPI_TICKETS 
WHERE 1=1
AND to_char(FINISH_TIME,'YYYY-MM-DD') between '2018-09-01'and '2018-09-03'
AND queue_finish in (SELECT name FROM queue WHERE name like 'SISTEMAS%')

-- SLA : SUPORTE TECNICO
SELECT  
ROUND((SUM(case when sla_attend = 'TRUE' then 1 else 0 end) * 100)/count(*),0) as perc
FROM VW_KPI_TICKETS 
WHERE 1=1
AND to_char(FINISH_TIME,'YYYY-MM-DD') between '2018-09-01'and '2018-09-03'
AND queue_finish in (SELECT name FROM queue WHERE name like 'SUPORTE TÉCNICO%')
