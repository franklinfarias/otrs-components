USE `otrs`;
DROP function IF EXISTS `fncTempoPendente`;

DELIMITER $$
USE `otrs`$$
CREATE FUNCTION `fncTempoPendente` (idTicket INTEGER)
RETURNS varchar(10)
BEGIN
  /* Criando variaveis do loop */
  DECLARE done INT DEFAULT FALSE;
  DECLARE historyId INT;
  DECLARE stateId INT;
  DECLARE queueId INT;
  DECLARE calendarId INT;
  DECLARE historyCreateTime DATETIME;
  DECLARE historyChangeTime DATETIME;
  DECLARE tempoTotal INT;

  DECLARE historyIdOld INT;
  DECLARE stateIdOld INT;
  DECLARE queueIdOld INT;
  DECLARE historyCreateTimeOld DATETIME;
  DECLARE historyChangeTimeOld DATETIME;
  
  /* Criando Cursor para o LOOP */
  DECLARE crHISTORY_TICKET CURSOR FOR SELECT 
        th.id AS history_id,
		s.calendar_name AS calendar_id,
        th.state_id, 
        th.queue_id,
        th.create_time AS history_create_time,
        th.change_time AS history_change_time
   FROM ticket_history th
   JOIN ticket t ON th.ticket_id = t.id
   JOIN sla s ON t.sla_id = s.id
  WHERE 1 = 1
    AND th.ticket_id = idTicket
    AND history_type_id IN (1,16,27)
  ORDER BY th.id;
  -- DECLARE EXIT HANDLER FOR NOT FOUND BEGIN END;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  /* Inicializando variaveis */
  SET tempoTotal = 0;
  SET historyIdOld = 0;
  SET stateIdOld = 0;
  SET queueIdOld = 0;
  SET historyCreateTimeOld = 0;
  SET historyChangeTimeOld = 0;

  OPEN crHISTORY_TICKET;

  -- LOOP
  read_loop: LOOP 
      -- Obtem os valores da linha
      FETCH crHISTORY_TICKET INTO historyId, calendarId, stateId, queueId, historyCreateTime, historyChangeTime;

      IF done THEN
        LEAVE read_loop;
      END IF;
  	  
      IF (stateIdOld IN (6)) THEN
         -- Soma tempo
         SET tempoTotal = tempoTotal + fncTime2ToInt(fncTotalHorasUteis(calendarId, historyCreateTimeOld, historyCreateTime));
		 -- SET tempoTotal = tempoTotal;
      END IF;
      -- Reinicia as variaveis do proximo Registro
      SET historyCreateTimeOld = historyCreateTime;
      SET historyChangeTimeOld = historyChangeTime;
      SET stateIdOld = stateId; 
      SET queueIdOld = queueId; 
  END LOOP;
  
  -- Soma tempo se estado atual eh PENDENTE
  IF (stateId IN (6)) THEN
      SET tempoTotal = tempoTotal + fncTime2ToInt(fncTotalHorasUteis(calendarId, CURRENT_TIMESTAMP, historyCreateTimeOld));  
  END IF;

  CLOSE crHISTORY_TICKET;
  
  RETURN fncIntToTime(tempoTotal);
END$$

DELIMITER ;

