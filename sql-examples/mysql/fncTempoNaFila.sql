USE `otrs`;
DROP function IF EXISTS `fncTempoNaFila`;

DELIMITER $$
USE `otrs`$$
CREATE FUNCTION `fncTempoNaFila` (idTicket INTEGER, idFila INTEGER)
RETURNS varchar(10)
BEGIN

  /* Criando variaveis do loop */
  DECLARE historyId INT;
  DECLARE queueId INT;
  DECLARE historyCreateTime DATETIME;
  DECLARE historyChangeTime DATETIME;
  DECLARE tempoTotal INT;

  DECLARE historyIdOld INT;
  DECLARE queueIdOld INT;
  DECLARE historyCreateTimeOld DATETIME;
  DECLARE historyChangeTimeOld DATETIME;
  
  /* Criando Cursor para o LOOP */
  DECLARE crHISTORY_TICKET CURSOR FOR SELECT 
        th.id AS history_id, 
        th.queue_id,
        th.create_time AS history_create_time,
        th.change_time AS history_change_time
   FROM ticket_history th
  WHERE 1 = 1
    AND th.ticket_id = idTicket
  ORDER BY th.id;
  DECLARE EXIT HANDLER FOR NOT FOUND BEGIN END;   

  /* Inicializando variaveis */
  SET tempoTotal = 0;
  SET historyIdOld = 0;
  SET queueIdOld = 0;
  SET historyCreateTimeOld = 0;
  SET historyChangeTimeOld = 0;

  OPEN crHISTORY_TICKET;
  -- LOOP
  LOOP
      -- Obtem os valores da linha
      FETCH crHISTORY_TICKET INTO historyId, queueId, historyCreateTime, historyChangeTime;
  	  
      -- Realiza a soma de Tempos
      IF (queueId = IdQueue) and (queueId <> queueIdOld) THEN
         SET historyCreateTimeOld = historyCreateTime;
         SET historyChangeTimeOld = historyChangeTime;
         -- Soma o Tempo
         SET tempoTotal = tempoTotal + fncTimeToInt(CONCAT('2014-01-01 ', fncTotalHorasUteis(historyCreateTimeOld, historyCreateTime)));
      END IF;
      
      -- Reinicia as variaveis do proximo Registro
      SET queueIdOld = queueId;
      
  END LOOP;

  CLOSE crHISTORY_TICKET;
  
  RETURN fncIntToTime(tempoTotal);
  
END$$

DELIMITER ;


