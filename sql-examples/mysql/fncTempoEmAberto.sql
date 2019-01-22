USE `otrs`;
DROP function IF EXISTS `fncTempoEmAberto`;

DELIMITER $$
USE `otrs`$$
CREATE FUNCTION `fncTempoEmAberto` (idTicket integer)
RETURNS varchar(10)
BEGIN
  /* Criando variaveis do loop */
  declare done int default false;
  declare historyId int;
  declare stateId int;
  declare queueId int;
  declare calendarId int;
  declare historyCreateTime datetime;
  declare historyChangeTime datetime;
  declare tempoTotal int;

  declare historyIdOld int;
  declare stateIdOld int;
  declare queueIdOld int;
  declare historyCreateTimeOld datetime;
  declare historyChangeTimeOld datetime;
  
  /* Criando Cursor para o LOOP */
  declare crHISTORY_TICKET cursor for select 
        th.id as history_id,
		coalesce(s.calendar_name,1) AS calendar_id,
        th.state_id, 
        th.queue_id,
        th.create_time as history_create_time,
        th.change_time as history_change_time
   from ticket_history th
   join ticket t on th.ticket_id = t.id
   left join sla s ON t.sla_id = s.id
  where 1 = 1
    and th.ticket_id = idTicket
    and history_type_id in (1,27)
  order by th.id;
  -- DECLARE EXIT HANDLER FOR NOT FOUND BEGIN END;
  declare continue handler for not found set done = true;

  /* Inicializando variaveis */
  set tempoTotal = 0;
  set historyIdOld = 0;
  set stateIdOld = 0;
  set queueIdOld = 0;
  set historyCreateTimeOld = 0;
  set historyChangeTimeOld = 0;

  open crHISTORY_TICKET;

  -- LOOP
  read_loop: loop 
      -- Obtem os valores da linha
      fetch crHISTORY_TICKET into historyId, calendarId, stateId, queueId, historyCreateTime, historyChangeTime;

      if done then
        leave read_loop;
      end if;
  	  
      if (stateIdOld in (1,4,5,6)) then
         -- Soma tempo
         set tempoTotal = tempoTotal + fncTime2ToInt(fncTotalHorasUteis(calendarId,historyCreateTimeOld, historyCreateTime));
      end if;
      -- Reinicia as variaveis do proximo Registro
      set historyCreateTimeOld = historyCreateTime;
      set historyChangeTimeOld = historyChangeTime;
      set stateIdOld = stateId; 
      set queueIdOld = queueId; 
  end loop;

  close crHISTORY_TICKET;
  
  return fncIntToTime(tempoTotal);
END$$

DELIMITER ;

