-- 
-- Modelo de consulta padrao para extracao da dados
-- Use FINISH_TIME para obter os chamados que encerrados
-- Use SLA_SOLUTION_TIME tempo definido para resolucao do chamado
-- Use TIME_OPENED tempo que o chamado ficou no tipo de estado ABERTO
-- Use TIME_PENDING tempo que o chamado ficou pendente
-- Use TIME_SOLUTION tempo que o chamado ficou RESOLVIDO
-- Use SLA_ATTEND qdo ha SLA verifica se esta dentro ou fora
-- Use USER_FINISH tecnico que concluiu o chamado
-- Use COMMUNICATION_CHANNEL tipo de abertura do chamado (phone,email,web,chat)
-- 
SELECT
*
FROM VW_KPI_TICKETS
WHERE 1 = 1
;