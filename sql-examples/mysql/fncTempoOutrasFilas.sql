CREATE DEFINER=`root`@`%` FUNCTION `fncTempoOutrasFilas`(idTicket INT) RETURNS varchar(10) CHARSET utf8
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
        th.state_id, 
        th.queue_id,
        sla.calendar_name,
        th.create_time AS history_create_time,
        th.change_time AS history_change_time
   FROM ticket_history th
   JOIN ticket t ON th.ticket_id = t.id
   JOIN sla sla ON t.sla_id = sla.id
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
      FETCH crHISTORY_TICKET INTO historyId, stateId, queueId, calendarId, historyCreateTime, historyChangeTime;

      IF done THEN
        LEAVE read_loop;
      END IF;
  	  
      IF (queueIdOld IN (11,12,13,15)) AND (stateIdOld IN (1,4,5)) THEN
         -- Soma tempo
         SET tempoTotal = tempoTotal + fncTimeToInt(CONCAT('2014-01-01 ', fncTotalHorasUteis(calendarId, historyCreateTimeOld, historyCreateTime)));
      END IF;
      -- Reinicia as variaveis do proximo Registro
      SET historyCreateTimeOld = historyCreateTime;
      SET historyChangeTimeOld = historyChangeTime;
      SET stateIdOld = stateId; 
      SET queueIdOld = queueId; 
  END LOOP;

  CLOSE crHISTORY_TICKET;
  
  RETURN fncIntToTime(tempoTotal);
END