USE `otrs`;

-- Tabelas
drop table if exists fks_feriados;
 
create table fks_feriados (
  dt_feriado date not null,
  name_feriado varchar(150) default null,
  constraint dt_feriado_pk primary key (dt_feriado)
);

--
-- INSERE CALENDÁRIO MPOG 2018
insert into fks_feriados(dt_feriado,name_feriado) values ('2018-01-01','yyyy-mm-dd','confraternização universal (feriado nacional)');
insert into fks_feriados(dt_feriado,name_feriado) values ('2018-02-12','yyyy-mm-dd','carnaval (ponto facultativo)');
insert into fks_feriados(dt_feriado,name_feriado) values ('2018-02-13','yyyy-mm-dd','carnaval (ponto facultativo)');
insert into fks_feriados(dt_feriado,name_feriado) values ('2018-02-14','yyyy-mm-dd','quarta-feira de cinzas (ponto facultativo até as 14 horas)');
insert into fks_feriados(dt_feriado,name_feriado) values ('2018-03-30','yyyy-mm-dd','paixão de cristo (feriado nacional)');
insert into fks_feriados(dt_feriado,name_feriado) values ('2018-04-21','yyyy-mm-dd','tiradentes (feriado nacional)');
insert into fks_feriados(dt_feriado,name_feriado) values ('2018-05-01','yyyy-mm-dd','dia mundial do trabalho (feriado nacional)');
insert into fks_feriados(dt_feriado,name_feriado) values ('2018-05-31','yyyy-mm-dd','corpus christi (ponto facultativo)');
insert into fks_feriados(dt_feriado,name_feriado) values ('2018-09-07','yyyy-mm-dd','independência do brasil (feriado nacional)');
insert into fks_feriados(dt_feriado,name_feriado) values ('2018-10-12','yyyy-mm-dd','nossa senhora aparecida (feriado nacional)');
insert into fks_feriados(dt_feriado,name_feriado) values ('2018-10-28','yyyy-mm-dd','dia do servidor público - art. 236 da lei nº 8.112, de 11 de dezembro de 1990 (ponto facultativo)');
insert into fks_feriados(dt_feriado,name_feriado) values ('2018-11-02','yyyy-mm-dd','finados (feriado nacional)');
insert into fks_feriados(dt_feriado,name_feriado) values ('2018-11-15','yyyy-mm-dd','proclamação da república (feriado nacional) e');
insert into fks_feriados(dt_feriado,name_feriado) values ('2018-12-25','yyyy-mm-dd','natal (feriado nacional)');

USE `otrs`;
DROP function IF EXISTS `fncRemTagHtml`;

DELIMITER $$
USE `otrs`$$
CREATE FUNCTION `fncRemTagHtml` (Dirty varchar(4000))
RETURNS varchar(4000)
BEGIN
  DECLARE iStart, iEnd, iLength int;
    WHILE Locate( '<', Dirty ) > 0 And Locate( '>', Dirty, Locate( '<', Dirty )) > 0 DO
      BEGIN
        SET iStart = Locate( '<', Dirty ), iEnd = Locate( '>', Dirty, Locate('<', Dirty ));
        SET iLength = ( iEnd - iStart) + 1;
        IF iLength > 0 THEN
          BEGIN
            SET Dirty = Insert( Dirty, iStart, iLength, '');
          END;
        END IF;
      END;
    END WHILE;
    RETURN Dirty;
END$$

DELIMITER ;

USE `otrs`;
DROP function IF EXISTS `fncIntToTime`;

DELIMITER $$
USE `otrs`$$
CREATE FUNCTION `fncIntToTime` (dtData INT)
RETURNS varchar(8)
COMMENT 'Retorna Hora no formato HH:MM:SS'
BEGIN
    DECLARE sumHoras INT;
    DECLARE horaCalc INT;
    DECLARE minutoCalc INT;
    DECLARE segundoCalc INT;
    /*-->> Método para cálculo de HORAS*/
    SET sumHoras = dtData;
    SET horaCalc = FLOOR(sumHoras / 3600);
    SET sumHoras = sumHoras - (horaCalc * 3600);
    SET minutoCalc = FLOOR(sumHoras / 60);
    SET sumHoras = sumHoras - (minutoCalc * 60);
    SET segundoCalc = sumHoras;
    RETURN CAST(CONCAT(horaCalc,':',minutoCalc,':',segundoCalc) AS TIME);
END$$

DELIMITER ;

USE `otrs`;
DROP function IF EXISTS `fncTimeToInt`;

DELIMITER $$
USE `otrs`$$
CREATE FUNCTION `fncTimeToInt` (dtData DATETIME)
RETURNS INTEGER
BEGIN

	RETURN HOUR(dtData) * 3600 + MINUTE(dtData) * 60 + SECOND(dtData);
END$$

DELIMITER ;

USE `otrs`;
DROP function IF EXISTS `fncTime2ToInt`;

DELIMITER $$
USE `otrs`$$
CREATE FUNCTION `fncTime2ToInt` (tTime TIME)
RETURNS INTEGER
BEGIN
	RETURN HOUR(tTime) * 3600 + MINUTE(tTime) * 60 + SECOND(tTime);
END$$

DELIMITER ;

USE `otrs`;
DROP function IF EXISTS `fncHoursToInt`;

DELIMITER $$
USE `otrs`$$
CREATE FUNCTION `fncHoursToInt` (dtData DATETIME)
RETURNS INTEGER
BEGIN
   RETURN ((HOUR(dtData) * 3600) + (MINUTE(dtData) * 60) + SECOND(dtData));
END$$

DELIMITER ;

USE `otrs`;
DROP function IF EXISTS `fncIntToHours`;

DELIMITER $$
USE `otrs`$$
CREATE FUNCTION `fncIntToHours` (dtData INTEGER)
RETURNS INTEGER
BEGIN
DECLARE sumHoras INTEGER;
    DECLARE horaCalc INTEGER;
    DECLARE minutoCalc INTEGER;
    DECLARE segundoCalc INTEGER;
    /*-->> Método para cálculo de HORAS*/
    SET sumHoras = dtData;
    SET horaCalc = FLOOR(sumHoras / 3600);
    SET sumHoras = sumHoras - (horaCalc * 3600);
    SET minutoCalc = FLOOR(sumHoras / 60);
    SET sumHoras = sumHoras - (minutoCalc * 60);
    SET segundoCalc = sumHoras;
    RETURN CAST(CONCAT(horaCalc,':',minutoCalc,':',segundoCalc) AS TIME);
END$$

DELIMITER ;

USE `otrs`;
DROP function IF EXISTS `fncTotalHorasUteis`;

DELIMITER $$
USE `otrs`$$
CREATE FUNCTION `fncTotalHorasUteis` (iCalendar INT, dtIni DATETIME, dtFim DATETIME)
RETURNS varchar(10)
BEGIN
	DECLARE iniTurno VARCHAR(8);
	DECLARE fimTurno VARCHAR(8);
	DECLARE retorno VARCHAR(10);
    DECLARE sumHoras INT;
    DECLARE countDias INT;
    DECLARE iCount INT;
    DECLARE horaIniACUMULADA INT;
    DECLARE horaFimACUMULADA INT;
    DECLARE horaCalc INT;
    DECLARE minutoCalc INT;
    DECLARE segundoCalc INT;
    DECLARE dataCalcIni DATETIME;
    DECLARE dataCalcFim DATETIME;
    DECLARE dataProxima DATETIME;

	-- Calcula inicio e termino do Turno do calendario
	IF (iCalendar = 1) THEN
        -- Central de Serviço
		SET iniTurno = '08:00:00';
		SET fimTurno = '20:00:00';
	ELSEIF (iCalendar = 2) THEN
			-- Analise&Suporte
			SET iniTurno = '09:00:00';
			SET fimTurno = '19:00:00';
	ELSE
        -- Suporte24H
		SET iniTurno = '00:00:00';
		SET fimTurno = '23:59:59';
	END IF;
    
	IF (ABS(DATEDIFF(dtFim,dtIni)) = 0) THEN
		-- Tratando DataHora inicial
    	IF (fncTimeToInt(dtIni) < fncTime2ToInt(iniTurno)) THEN
			-- Se o tempo é ANTERIOR ao HorarioTrabalho
			SET dataCalcIni = TIMESTAMPADD(HOUR,SUBSTRING(iniTurno,1,2),DATE(dtIni));
		ELSE
			IF (fncTimeToInt(dtIni) > fncTime2ToInt(fimTurno)) THEN
				-- Se o tempo é POSTERIOR ao HorarioTrabalho
				SET dataCalcIni = TIMESTAMPADD(HOUR,SUBSTRING(iniTurno,1,2),DATE(dtIni));
			ELSE
				SET dataCalcIni = dtIni;
			END IF;
		END IF;
		-- Tratando DataHora final
		IF (fncTimeToInt(dtFim) > fncTime2ToInt(fimTurno)) THEN
			-- Se o tempo é POSTERIOR ao HorarioTrabalho
			IF (fncTimeToInt(dtIni) > fncTime2ToInt(fimTurno)) THEN
				SET dataCalcFim = TIMESTAMPADD(HOUR,SUBSTRING(iniTurno,1,2),DATE(dtIni));
			ELSE
				SET dataCalcFim = TIMESTAMPADD(HOUR,SUBSTRING(fimTurno,1,2),DATE(dtFim));
			END IF;
		ELSE
			IF (fncTimeToInt(dtFim) < fncTime2ToInt(iniTurno)) THEN
				-- Se o tempo é ANTERIOR ao HorarioTrabalho
				SET dataCalcFim = TIMESTAMPADD(HOUR,SUBSTRING(iniTurno,1,2),DATE(dtIni));
			ELSE
				SET dataCalcFim = dtFim;
			END IF;
		END IF;
		SET retorno = TIMEDIFF(dataCalcFim,dataCalcIni);
    ELSE
        /*-->> Método para cálculo de HORAS*/
        -- Soma Horas finais do primeiro Dia
        SET horaIniACUMULADA = (HOUR(dtIni) * 3600) + (MINUTE(dtIni) * 60) + SECOND(dtIni);
        SET dataCalcFim = CAST(CONCAT(YEAR(dtIni),'-',MONTH(dtIni),'-',DAY(dtIni),' ',fimTurno) AS DATETIME);
        SET horaFimACUMULADA = (HOUR(dataCalcFim) * 3600) + (MINUTE(dataCalcFim) * 60) + SECOND(dataCalcFim);
        SET sumHoras = horaFimACUMULADA - horaIniACUMULADA;
        
        SET iCount = 1;
        SET countDias = ABS(DATEDIFF(dtFim,dtIni));
    	WHILE (iCount <= countDias) DO
        	SET dataProxima = DATE_ADD(dtIni, INTERVAL iCount DAY);
            -- Veriricar se a Proxima Data eh igual a Data Fim
            IF (DATE(dataProxima)=DATE(dtFim)) THEN
            	SET dataCalcIni = CAST(CONCAT(YEAR(dataProxima),'-',MONTH(dataProxima),'-',DAY(dataProxima),' ',iniTurno) AS DATETIME);
                SET horaIniACUMULADA = (HOUR(dataCalcIni) * 3600) + (MINUTE(dataCalcIni) * 60) + SECOND(dataCalcIni);
                SET horaFimACUMULADA = (HOUR(dtFim) * 3600) + (MINUTE(dtFim) * 60) + SECOND(dtFim);
                SET sumHoras = sumHoras + (horaFimACUMULADA - horaIniACUMULADA);
            ELSE
                -- Verificar FDS
                IF (DAYOFWEEK(dataProxima)<>1 AND DAYOFWEEK(dataProxima)<>7) THEN
            		-- Verificar Feriado
                	IF ((SELECT COUNT(*) FROM ios_feriados WHERE dt_feriado = DATE(dataProxima)) <= 0) THEN
                        SET dataCalcIni = CAST(CONCAT(YEAR(dataProxima),'-',MONTH(dataProxima),'-',DAY(dataProxima),' ', iniTurno) AS DATETIME);
                        SET dataCalcFim = CAST(CONCAT(YEAR(dataProxima),'-',MONTH(dataProxima),'-',DAY(dataProxima),' ', fimTurno) AS DATETIME);
                        SET horaIniACUMULADA = (HOUR(dataCalcIni) * 3600) + (MINUTE(dataCalcIni) * 60) + SECOND(dataCalcIni);
                        SET horaFimACUMULADA = (HOUR(dataCalcFim) * 3600) + (MINUTE(dataCalcFim) * 60) + SECOND(dataCalcFim);
                        SET sumHoras = sumHoras + (horaFimACUMULADA - horaIniACUMULADA);
                    END IF;
                END IF;
            END IF;
            SET iCount = iCount + 1;
        END WHILE;

    	/*-->> Método para cálculo de HORAS*/
        SET horaCalc = FLOOR(sumHoras / 3600);
        SET sumHoras = sumHoras - (horaCalc * 3600);
        SET minutoCalc = FLOOR(sumHoras / 60);
        SET sumHoras = sumHoras - (minutoCalc * 60);
        SET segundoCalc = sumHoras;
        -- SET retorno = CAST(CONCAT(horaCalc,':',minutoCalc,':',segundoCalc) AS TIME);
        SET retorno = CONCAT(lpad(horaCalc,2,'0'),':',minutoCalc,':',segundoCalc);
	END IF;

  	RETURN retorno;
END$$

DELIMITER ;

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


-- -----------------
-- -----------------

-- 
-- Visões
drop view if exists vw_last_closed;
create view vw_last_closed as
    select
        ticket_history.ticket_id as ticket_id,
        max(ticket_history.id) as history_id
    from ticket_history
    where ticket_history.history_type_id = 27
    -- and ticket_history.queue_id <> 35
  and ticket_history.state_id in (select id from ticket_state where type_id = 3)
    group by ticket_history.ticket_id
;
drop view if exists vw_first_article;
create view vw_first_article as
    select
        a.ticket_id as ticket_id,
        cc.id as communication_channel_id, cc.name as communication_channel,
        min(a.id) as article_id
    from article a
    join communication_channel cc on a.communication_channel_id = cc.id
    group by a.ticket_id, cc.id, cc.name
;
drop view if exists vw_comm_channel;
create view vw_comm_channel as
select
        fa.ticket_id, fa.article_id, cc.id as communication_channel_id, cc.name as communication_channel
    from vw_first_article fa 
    join article a on fa.article_id = a.id
    join communication_channel cc on a.communication_channel_id = cc.id
;
drop view if exists vw_first_history;
create view vw_first_history as
select min(th.id) as history_id, th.ticket_id
  from ticket_history th
group by th.ticket_id
;
drop view if exists vw_first_move;
create view vw_first_move as
select min(th.id) as history_id, th.ticket_id
  from ticket_history th
where history_type_id = 16
group by th.ticket_id
;
drop view if exists vw_qtd_move;
create view vw_qtd_move as
select ticket_id, count(id) as qtd_move
from ticket_history
where history_type_id = 16
-- and queue_id not in (23,35)
group by ticket_id
;
drop view if exists vw_last_state_history;
create view vw_last_state_history as
    select
        th.ticket_id as ticket_id,
        max(th.id) as history_id
    from ticket_history th
    where th.history_type_id = 27
    group by th.ticket_id
;
drop view if exists vw_all_tickets_finish;
create view vw_all_tickets_finish as
    select
        max(th.id) as history_id,
        th.ticket_id as ticket_id
    from ticket_history th
    WHERE th.history_type_id = 27
      and th.state_id in (select id from ticket_state where type_id in (3)) -- closed
    group by th.ticket_id
;
drop view if exists vw_bypass_cs; 
create view vw_bypass_cs as
select min(id) as history_id, ticket_id
from ticket_history
where history_type_id in (1,16)
and queue_id in (select id from queue where upper(name) like 'CENTRAL%')
group by ticket_id
;
drop view if exists vw_first_contact; 
create view vw_first_contact as
select min(id) as history_id, ticket_id
from ticket_history
where history_type_id in (14) -- PhoneCallCustomer
group by ticket_id
;
-- Primeiro contato via telefone
drop view if exists vw_tempo_resposta;
create view vw_tempo_resposta as
select fc.history_id, fc.ticket_id, th.create_time as time_response
from vw_first_contact fc
join ticket_history th on fc.history_id = th.id
where 1=1
;
drop view if exists vw_start_attend;
create view vw_start_attend as
select min(id) as history_id, ticket_id
from ticket_history
where history_type_id in (27) -- StateUpdate
and state_id = (select id from ticket_state where upper(name) like 'EM%ANDAMENTO%') -- In attendance
group by ticket_id
;
-- Início tratamento Equipe
drop view if exists vw_tempo_atendimento;
create view vw_tempo_atendimento as
select sa.history_id, sa.ticket_id, th.create_time as time_attend
from vw_start_attend sa
join ticket_history th on sa.history_id = th.id
where 1=1
;
drop view if exists vw_tickets_encerrados;
create view vw_tickets_encerrados as
select
    t.id as ticket_id,
    t.create_time as create_time,
    thf.queue_id as queue_create,
    thf.state_id as state_create,
    th.change_time as finish_time,
    th.queue_id as queue_finish,
    th.create_by as user_finish
from vw_all_tickets_finish atf
join vw_last_closed lc on atf.ticket_id = lc.ticket_id
join vw_first_history fh on atf.ticket_id = fh.ticket_id
    join ticket t on atf.ticket_id = t.id
    join ticket_history th on th.id = lc.history_id
join ticket_history thf on thf.id = fh.history_id
;
-- 
drop view if exists vw_kpi;
create view vw_kpi as
select
t.id as ticket_id, t.tn, t.title, t.create_time,
tt.id as type_id, tt.name as type_name,
tp.id as priority_id, tp.name as priority_name,
ts.id as state_id, ts.name as state_name,
s.id as service_id, s.name as service_name,
te.queue_create, q1.name as queue_create_name,
te.queue_finish, q2.name as queue_finish_name,
te.finish_time,
te.user_finish as user_finish_id, concat(u.first_name,' ',u.last_name) as user_finish,
sla.name AS sla_name,
coalesce(sla.calendar_name,'9') AS calendar_name,
sla.first_response_time AS first_response_time,
sla.solution_time AS solution_time,
fncTime2ToMin(fncTempoPendente(te.ticket_id)) AS time_pending,
-- time_response = É o período de tempo transcorrido entre a abertura de um chamado e o primeiro contato, via telefone
fncTime2ToMin(fncTotalHorasUteis(sla.calendar_name,t.create_time,tr.time_response)) AS time_response,
-- time_attend = É o período de tempo transcorrido entre a abertura de um chamado e a mudança de situação para Em atendimento
fncTime2ToMin(fncTotalHorasUteis(sla.calendar_name,t.create_time,ta.time_attend)) AS time_attend,
-- time_attend = É o período de tempo transcorrido entre a abertura de um chamado e a efetiva resolução do atendimento
fncTime2ToMin(fncTotalHorasUteis(sla.calendar_name,t.create_time,te.finish_time)) AS time_solution
from vw_tickets_encerrados te
join ticket t ON te.ticket_id = t.id
join ticket_state ts ON t.ticket_state_id = ts.id
join ticket_type tt ON t.type_id = tt.id
join ticket_priority tp on t.ticket_priority_id = tp.id
join queue q1 ON te.queue_create = q1.id
join queue q2 ON te.queue_finish = q2.id
join users u ON te.user_finish = u.id
join service s ON t.service_id = s.id
join sla ON t.sla_id = sla.id
left join vw_tempo_resposta tr ON t.id = tr.ticket_id
left join vw_tempo_atendimento ta ON t.id = ta.ticket_id
where 1=1
;
--
drop view if exists vw_kpi_stats;
create view vw_kpi_stats as
select
kpi.*
,case when kpi.time_response > kpi.first_response_time then 1 else 0 end sla_response_violate
,case when (kpi.time_solution - kpi.time_pending) > kpi.solution_time then 1 else 0 end sla_solution_violate
from vw_kpi kpi
where 1=1
; 
--
drop view if exists vw_kpi_pqs;
create view vw_kpi_pqs as
select
s.id as survey_id, s.status,
sq.id as question_id, sq.question, sq.position,
sr.id as request_id, sr.public_survey_key, sr.send_to, sr.send_time, sr.vote_time,
t.id as ticket_id, t.tn, t.title, t.create_time,
te.queue_finish,
te.finish_time,
tt.name as type_name,
ts.name as state_name,
srv.name as service_name,
q1.name as queue_create_name,
q2.name as queue_finish_name,
te.user_finish,
sv.id as vote_id, fnRemTagHtml(replace(sv.vote_value,'$html/text$','')) as vote_value
, sa.answer
, case when sv.vote_value in (1,2,5,6,9,10,13,14) then 1 else null end as satisfaction
, case when sv.vote_value in (4,8,12,16) then 1 else null end as nosatisfaction
from survey s
join survey_question sq on s.id = sq.survey_id
join survey_request sr on s.id = sr.survey_id
join ticket t on sr.ticket_id = t.id
join ticket_type tt on t.type_id = tt.id
join ticket_state ts on t.ticket_state_id = ts.id
join vw_tickets_encerrados te on t.id = te.ticket_id
join queue q1 on te.queue_create = q1.id
join queue q2 on te.queue_finish = q2.id
left join survey_vote sv on sq.id = sv.question_id and sr.id = sv.request_id
left join survey_answer sa on sv.vote_value = sa.id
left join service srv on t.service_id = srv.id
where 1=1
and s.id = 2
order by sr.ticket_id, sq.position
; 
--
drop view if exists vw_survey_questions;
create view vw_survey_questions as
select
  s.id as survey_id,
  s.title as title,
  s.status as status,
  s.description as description,
  sq.id as question_id,
  sq.question as question,
  sq.question_type as question_type,
  sq.position as position,
  sq.answer_required as answer_required,
  sq.create_by as create_by,
  sq.create_time as create_time
from survey_question sq
join survey s on sq.survey_id = s.id and s.status = 'Master'
order by sq.position
;
--
drop view if exists vw_survey_answers_textarea;
create view vw_survey_answers_textarea as
select
  sv.question_id as question_id,
  cast(sv.create_time as date) as date_vote,
  (case
    when (sv.vote_value <> '') then 1
    else 0
  end) as amount_answered,
  (case
    when (sv.vote_value = '') then 1
    else 0
  end) as amount_not_answered
from survey_vote sv
join survey_question sq on sv.question_id = sq.id and sq.question_type = 'Textarea'
;
--
drop view if exists vw_survey_answers;
create view vw_survey_answers as
select
  sq.id as question_id,
  sq.question as question,
  sq.position as pos_question,
  sa.id as answer_id,
  sa.answer as answer,
  sa.position as pos_answer,
  coalesce(cast(sv.create_time as date),
      sat.date_vote) as date_vote,
  count(sv.id) as amount,
  sum(sat.amount_answered) as amount_answered,
  sum(sat.amount_not_answered) as amount_not_answered
from survey_question sq
left join survey_answer sa on sq.id = sa.question_id
left join survey_vote sv on sa.id = sv.vote_value
left join vw_survey_answers_textarea sat on sq.id = sat.question_id
group by sq.id , sq.question , sq.position , sa.id , sa.answer , sa.position , coalesce(cast(sv.create_time as date),sat.date_vote)
order by sq.position , sa.position
;
--
drop view if exists vw_notify_resolution;
create view vw_notify_resolution as
select distinct a.ticket_id
from article a
join article_data_mime adm on a.id = adm.article_id
where 1=1
and adm.a_subject LIKE '%Resolução do Chamado%'
;
--
drop view if exists vw_kpi_notificacao;
create view vw_kpi_notificacao as
select
kpi.*
from vw_kpi kpi
where kpi.ticket_id not in (select ticket_id from vw_notify_resolution)
;
--
drop view if exists vw_reopen;
create view vw_reopen as
select
t.id as ticket_id, (count(*) -1) as qtd_reopen
from ticket_history th
join ticket t on th.ticket_id = t.id
where 1=1
and th.history_type_id = 27 -- StateUpdate
and th.state_id in (select id from ticket_state where type_id in (3)) -- closed
group by t.id, t.tn
having count(*) >= 2
;
--
drop view if exists vw_tickets_reabertos;
create view vw_tickets_reabertos as
select
kpi.*
from vw_kpi kpi
where kpi.ticket_id in (select ticket_id from vw_reopen)
;
--
drop view if exists vw_tickets_ola_sub;
create view vw_tickets_ola_sub as
select min(th.id) as history_id, th.ticket_id
    from ticket_history th
   where history_type_id = 16 -- move
--       and queue_id = 27
   group by th.ticket_id
;
--
-- Tempo encaminhamento OLA
drop view if exists vw_tickets_ola;
create view vw_tickets_ola as
select
kpi.*,
th.change_time as move_ola,
fncTotalHorasUteis(1,kpi.create_time,th.change_time) as time_move_ola
from vw_kpi kpi
join vw_tickets_ola_sub ola on kpi.ticket_id = ola.ticket_id
join ticket_history th on ola.history_id = th.id
;
--
drop view if exists vw_user_role;
create view vw_user_role as
select
r.id as role_id,
r.name as role_name,
u.id as user_id,
u.first_name, u.last_name
from roles r
join role_user ru on r.id = ru.role_id
join users u on ru.user_id = u.id
;
--
drop view if exists vw_sla_fulfill;
create view vw_sla_fulfill as
select
*
from vw_kpi
where 1=1
and (time_solution - time_pending) <= 14400
;
--
drop view if exists vw_sla_violate;
create view vw_sla_violate as
select
*
from vw_kpi
where 1=1
and (time_solution - time_pending) > 14400
;
--
drop view if exists vw_ticket_ci;
create view vw_ticket_ci AS
select t.id as ticket_id, t.tn,
lr.*
from link_relation lr
join ticket t on lr.source_key = t.id and lr.source_object_id = 1
join configitem ci on lr.target_key = ci.id and lr.target_object_id = 2
;
--
drop view if exists vw_ticket_stat_general;
create view vw_ticket_stat_general as
select
1 as id, 'Tickets sem Serviço' as title, count(*) as qtd from ticket where coalesce(service_id,0) = 0
union
select
2 as id, 'Tickets sem CI' as title, count(*) as qtd from ticket where id not in (select ticket_id from vw_ticket_ci)
union
select
3 as id, 'Notificações enviadas aos Clientes' as title, count(*) from ticket_history where history_type_id = 10 -- SendCustomerNotification
union
select
4 as id, 'Ligações de Retorno(Agente)' as title, count(*) from ticket_history where history_type_id = 13 -- PhoneCallAgent
union
select
5 as id, 'Ligações de Retorno(Cliente)' as title, count(*) from ticket_history where history_type_id = 14 -- PhoneCallCustomer
union
select
6 as id, 'Respostas por Email' as title, count(*) from ticket_history where history_type_id = 8 -- SendAnswer
union
select
7 as id, 'Atividades Extras' as title, count(*) from ticket_history where history_type_id = 25 -- Misc
union
select
8 as id, 'Tickets Aberto por Email' as title, count(*) from vw_first_article where communication_channel_id = 1 --email
union
select
9 as id, 'Tickets Aberto por Telefone' as title, count(*) from vw_first_article where communication_channel_id = 2 --Phone
union
select
10 as id, 'Tickets Aberto por Self-Service' as title, count(*) from vw_first_article where communication_channel_id = 3 --internal
;

--
-- The next view is a most value function on this program. This representation all life cicle from the ticket.
--
drop view if exists vw_kpi_tickets;
create view vw_kpi_tickets as
select 
  t.id as ticket_id,
  t.tn as tn,
  t.create_time as create_time,
  t.title as title,
  ts.name as state_name,
  tt.name as type_name,
  tp.name as pririty_name,
  q1.name as queue_create,
  q3.name as queue_actual,
  q2.name as queue_finish,
  te.finish_time as finish_time,
  concat(u.first_name,' ',u.last_name) as user_finish,
  concat(u2.first_name,' ',u2.last_name) as user_create,
  fa.communication_channel,
  t.service_id as service_id,
  s.name as service_name,
  t.sla_id as sla_id,
  sla.name as sla_name,
  replace(substr(sla.comments,1,instr(sla.comments,';')-1),'ust=') as sla_ust, 
  replace(substr(sla.comments,instr(sla.comments,';')+1,length(sla.comments)),'vlr=') as sla_ust_vlr,
  fncinttotime(sla.first_response_time * 60) as sla_response_time,
  fncinttotime(sla.solution_time * 60) as sla_solution_time,
  fnctempoemaberto(t.id) as time_opened,
  fnctempopendente(t.id) as time_pending,
  fnctotalhorasuteis(sla.calendar_name,t.create_time,te.finish_time) as time_solution,
  case when (fnctime2toint(fnctotalhorasuteis(sla.calendar_name,t.create_time,te.finish_time)) - fnctime2toint(fnctempopendente(t.id))) <= (sla.solution_time * 60)
    then
      'true'
    else 
      case when (coalesce(sla.solution_time, 0) * 60) = 0 then 'true' else 'false' end
  end as sla_attend,
  coalesce(t.customer_id, '') as customer_id,
  t.customer_user_id as customer_user_id
from vw_tickets_encerrados te
join ticket t on te.ticket_id = t.id 
join ticket_type tt on t.type_id = tt.id
join ticket_priority tp on t.ticket_priority_id = tp.id
join ticket_state ts on t.ticket_state_id = ts.id
join vw_first_history fh on t.id = fh.ticket_id
join ticket_history thf on thf.id = fh.history_id
join queue q3 on t.queue_id = q3.id
join vw_comm_channel fa on t.id = fa.ticket_id
left join queue q1 on thf.queue_id = q1.id
left join queue q2 on te.queue_finish = q2.id
left join users u on te.user_finish = u.id
left join users u1 on t.change_by = u1.id
left join users u2 on t.create_by = u2.id
left join service s on t.service_id = s.id
left join sla on t.sla_id = sla.id
where 1 = 1
;