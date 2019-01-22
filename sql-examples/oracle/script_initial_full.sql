--
-- Scripts inicial CLIENTES
-- Database version: Oracle 10g

--
-- Criacao do usuário da aplicacao
-- create user if not exists `u_franklin`@`%` identified by 'my_pass';
-- create user if not exists `u_dashotrs`@`%` identified by 'd@2h0t5s';

--
-- Atribuicao de permissoes ao usuario da aplicacao
-- * Observar que NÃO utilizamos a opção GRANT OPTION.
-- grant select, execute, show view, create temporary tables on bd_otrs_ancine.* to `u_dashotrs`@`%`;
-- Lembrando que ALL PRIVILEGES, concede direitos a todos os privilégios no nivel de tabela.
-- grant all privileges on bd_otrs_ancine.* to `u_franklin`@`%`;

alter session set current_schema = OTRS_MAPA;
 
-- Tabelas
drop table otrs_db.fks_feriados;
 
create table otrs_db.fks_feriados (
  dt_feriado date not null,
  name_feriado varchar(150) default null,
  constraint dt_feriado_pk primary key (dt_feriado)
);
 
--
-- INSERE CALENDÁRIO MPOG 2018
insert into otrs_db.fks_feriados(dt_feriado,name_feriado) values (to_date('2018-01-01','yyyy-mm-dd'),'confraternização universal (feriado nacional)');
insert into otrs_db.fks_feriados(dt_feriado,name_feriado) values (to_date('2018-02-12','yyyy-mm-dd'),'carnaval (ponto facultativo)');
insert into otrs_db.fks_feriados(dt_feriado,name_feriado) values (to_date('2018-02-13','yyyy-mm-dd'),'carnaval (ponto facultativo)');
insert into otrs_db.fks_feriados(dt_feriado,name_feriado) values (to_date('2018-02-14','yyyy-mm-dd'),'quarta-feira de cinzas (ponto facultativo até as 14 horas)');
insert into otrs_db.fks_feriados(dt_feriado,name_feriado) values (to_date('2018-03-30','yyyy-mm-dd'),'paixão de cristo (feriado nacional)');
insert into otrs_db.fks_feriados(dt_feriado,name_feriado) values (to_date('2018-04-21','yyyy-mm-dd'),'tiradentes (feriado nacional)');
insert into otrs_db.fks_feriados(dt_feriado,name_feriado) values (to_date('2018-05-01','yyyy-mm-dd'),'dia mundial do trabalho (feriado nacional)');
insert into otrs_db.fks_feriados(dt_feriado,name_feriado) values (to_date('2018-05-31','yyyy-mm-dd'),'corpus christi (ponto facultativo)');
insert into otrs_db.fks_feriados(dt_feriado,name_feriado) values (to_date('2018-09-07','yyyy-mm-dd'),'independência do brasil (feriado nacional)');
insert into otrs_db.fks_feriados(dt_feriado,name_feriado) values (to_date('2018-10-12','yyyy-mm-dd'),'nossa senhora aparecida (feriado nacional)');
insert into otrs_db.fks_feriados(dt_feriado,name_feriado) values (to_date('2018-10-28','yyyy-mm-dd'),'dia do servidor público - art. 236 da lei nº 8.112, de 11 de dezembro de 1990 (ponto facultativo)');
insert into otrs_db.fks_feriados(dt_feriado,name_feriado) values (to_date('2018-11-02','yyyy-mm-dd'),'finados (feriado nacional)');
insert into otrs_db.fks_feriados(dt_feriado,name_feriado) values (to_date('2018-11-15','yyyy-mm-dd'),'proclamação da república (feriado nacional) e');
insert into otrs_db.fks_feriados(dt_feriado,name_feriado) values (to_date('2018-12-25','yyyy-mm-dd'),'natal (feriado nacional)');
select * from otrs_db.fks_feriados;
 
--
-- FUNÇÕES
-- DEFINER=`U_DASHOTRS`@`%`
 
CREATE OR REPLACE FUNCTION otrs_db.FNCSPLITSTRING (S VARCHAR, DEL VARCHAR, I INTEGER) RETURN VARCHAR IS
  N INTEGER;
--  COMMENT 'RETORNA SPLIT DA STRING'
BEGIN
  RETURN regexp_substr (S, '[^'||DEL||']+', 1, I);
END;
 
CREATE OR REPLACE FUNCTION otrs_db.FNREMTAGHTML( DIRTY VARCHAR ) RETURN VARCHAR IS
--  COMMENT 'REMOVE AS TAG HTML DO TEXTO'
BEGIN
  RETURN REGEXP_REPLACE(DIRTY, '<.*?>');
END;
 
CREATE OR REPLACE FUNCTION otrs_db.DATEDIFF(DATEFIM DATE, DATEINI date) RETURN VARCHAR IS
BEGIN
  -- RETURN FNCINTTOTIME((DATEFIM - DATEINI) * 24 * 60 * 60);
  RETURN (DATEFIM - DATEINI);
END;
 
CREATE OR REPLACE FUNCTION otrs_db.FNCINTTOHOURS(DTDATA INTEGER) RETURN INTEGER IS
  SUMHORAS INTEGER;
  HORACALC INTEGER;
  MINUTOCALC INTEGER;
--    COMMENT 'RETORNA SOMENTE AS HORAS. SEGUNDOS SÃO DESCONSIDERADOS.'
BEGIN
    /*-->> MÉTODO PARA CÁLCULO DE HORAS*/
    SUMHORAS := DTDATA;
    HORACALC := FLOOR(SUMHORAS / 3600);
    SUMHORAS := SUMHORAS - (HORACALC * 3600);
    MINUTOCALC := (FLOOR(SUMHORAS / 60) * 0.01666);
    RETURN (HORACALC + MINUTOCALC);
END;
 
CREATE OR REPLACE FUNCTION otrs_db.FNCINTTOTIME(DTDATA INTEGER) RETURN VARCHAR IS
  SUMHORAS INTEGER;
  HORACALC INTEGER;
  MINUTOCALC INTEGER;
  SEGUNDOCALC INTEGER;
--    COMMENT 'RETORNA HORA NO FORMATO HH:MM:SS'
BEGIN
    /*-->> MÉTODO PARA CÁLCULO DE HORAS*/
    SUMHORAS := DTDATA;
    HORACALC := FLOOR(SUMHORAS / 3600);
    SUMHORAS := SUMHORAS - (HORACALC * 3600);
    MINUTOCALC := FLOOR(SUMHORAS / 60);
    SUMHORAS := SUMHORAS - (MINUTOCALC * 60);
    SEGUNDOCALC := SUMHORAS;
    RETURN LPAD(HORACALC,2,'0')||':'||LPAD(MINUTOCALC,2,'0')||':'||LPAD(SEGUNDOCALC,2,'0');
END;
 
CREATE OR REPLACE FUNCTION otrs_db.FNCTIMETOINT(DTDATA DATE) RETURN INTEGER IS
--  COMMENT 'RETORNA DATA/HORA NO FORMATO INTEIRO'
BEGIN
  RETURN TO_CHAR(DTDATA,'HH24') * 3600 + TO_CHAR(DTDATA,'MI') * 60 + TO_CHAR(DTDATA,'SS');
END;
 
CREATE OR REPLACE FUNCTION otrs_db.FNCTIME2TOINT(TTIME VARCHAR) RETURN INTEGER IS
  IHOUR INT;
  IMINUTE INT;
  ISECOND INT;
--  COMMENT 'RETORNA HORA NO FORMATO INTEIRO'
BEGIN
    IHOUR := FNCSPLITSTRING(TTIME,':',1);
    IMINUTE := FNCSPLITSTRING(TTIME,':',2);
    ISECOND := FNCSPLITSTRING(TTIME,':',3);
    RETURN (IHOUR * 3600) + (IMINUTE * 60) + ISECOND;
END;
 
CREATE OR REPLACE FUNCTION otrs_db.FNCTIME2TOMIN(TTIME DATE) RETURN INTEGER IS
--  COMMENT 'CONVERTE A HORA PARA MINUTOS'
BEGIN
  RETURN FLOOR(TO_CHAR(TTIME,'HH24') * 60 + TO_CHAR(TTIME,'MI') + TO_CHAR(TTIME,'SS') / 60);
END;
 
CREATE OR REPLACE FUNCTION otrs_db.FNCINTTOHOURS(DTDATA INTEGER) RETURN INTEGER IS
  SUMHORAS INTEGER;
  HORACALC INTEGER;
  MINUTOCALC INTEGER;
--    COMMENT 'RETORNA SOMENTE AS HORAS. SEGUNDOS SÃO DESCONSIDERADOS.'
BEGIN
    /*-->> MÉTODO PARA CÁLCULO DE HORAS*/
    SUMHORAS := DTDATA;
    HORACALC := FLOOR(SUMHORAS / 3600);
    SUMHORAS := SUMHORAS - (HORACALC * 3600);
    MINUTOCALC := (FLOOR(SUMHORAS / 60) * 0.01666);
    RETURN (HORACALC + MINUTOCALC);
END;
 
CREATE OR REPLACE FUNCTION otrs_db.TIMEDIFF(DATEFIM DATE, DATEINI date) RETURN VARCHAR IS
BEGIN
  RETURN FNCINTTOTIME((DATEFIM - DATEINI) * 24 * 60 * 60);
END;
 
CREATE OR REPLACE FUNCTION otrs_db.FNCTOTALHORASUTEIS(ICALENDAR INTEGER, DTINI DATE, DTFIM DATE) RETURN VARCHAR IS
  INITURNO VARCHAR(8);
  FIMTURNO VARCHAR(8);
  RETORNO VARCHAR(10);
  SUMHORAS INTEGER;
  COUNTDIAS INTEGER;
  ICOUNT INTEGER;
  HORAINIACUMULADA INTEGER;
  HORAFIMACUMULADA INTEGER;
  HORACALC INTEGER;
  MINUTOCALC INTEGER;
  SEGUNDOCALC INTEGER;
  DATACALCINI DATE;
  DATACALCFIM DATE;
  DATAPROXIMA DATE;
  ISELECT INTEGER;
-- COMMENT 'RETORNA O TEMPO EM HORAS ÚTEIS DE ACORDO COM CALENDÁRIO DE HORARIOS'
BEGIN
  -- CALCULA INICIO E TERMINO DO TURNO DO CALENDARIO
  IF (ICALENDAR = 1) THEN
        -- CENTRAL DE SERVIÇO
    INITURNO := '08:00:00';
    FIMTURNO := '20:00:00';
  ELSIF (ICALENDAR = 2) THEN
      -- ANALISE&SUPORTE
      INITURNO := '09:00:00';
      FIMTURNO := '19:00:00';
  ELSE
        -- SUPORTE24H
    INITURNO := '00:00:00';
    FIMTURNO := '23:59:59';
  END IF;
   
  IF (ABS(DATEDIFF(DTFIM,DTINI)) = 0) THEN
    -- TRATANDO DATAHORA INICIAL
      IF (FNCTIMETOINT(DTINI) < FNCTIME2TOINT(INITURNO)) THEN
      -- SE O TEMPO É ANTERIOR AO HORARIOTRABALHO ;;;  TIMESTAMPADD(HOUR,SUBSTRING(INITURNO,1,2),DATE(DTINI));
      DATACALCINI := (TO_TIMESTAMP(DTINI,'HH24:MI:SS') + (SUBSTR(INITURNO,1,2)/24));
    ELSE
      IF (FNCTIMETOINT(DTINI) > FNCTIME2TOINT(FIMTURNO)) THEN
        -- SE O TEMPO É POSTERIOR AO HORARIOTRABALHO ;;; TIMESTAMPADD(HOUR,SUBSTRING(INITURNO,1,2),DATE(DTINI));
        DATACALCINI := (TO_TIMESTAMP(DTINI,'HH24:MI:SS') + (SUBSTR(INITURNO,1,2)/24));
      ELSE
        DATACALCINI := DTINI;
      END IF;
    END IF;
    -- TRATANDO DATAHORA FINAL
    IF (FNCTIMETOINT(DTFIM) > FNCTIME2TOINT(FIMTURNO)) THEN
      -- SE O TEMPO É POSTERIOR AO HORARIOTRABALHO ;;; TIMESTAMPADD(HOUR,SUBSTRING(INITURNO,1,2),DATE(DTINI));
      IF (FNCTIMETOINT(DTINI) > FNCTIME2TOINT(FIMTURNO)) THEN
        DATACALCFIM := (TO_TIMESTAMP(DTINI,'HH24:MI:SS') + (SUBSTR(INITURNO,1,2)/24));
      ELSE -- TIMESTAMPADD(HOUR,SUBSTRING(FIMTURNO,1,2),DATE(DTFIM));
        DATACALCFIM := (TO_TIMESTAMP(DTFIM,'HH24:MI:SS') + (SUBSTR(FIMTURNO,1,2)/24));
      END IF;
    ELSE
      IF (FNCTIMETOINT(DTFIM) < FNCTIME2TOINT(INITURNO)) THEN
        -- SE O TEMPO É ANTERIOR AO HORARIOTRABALHO ;;; TIMESTAMPADD(HOUR,SUBSTRING(INITURNO,1,2),DATE(DTINI));
        DATACALCFIM := TO_TIMESTAMP(DTINI,'HH24:MI:SS') + (SUBSTR(INITURNO,1,2)/24);
      ELSE
        DATACALCFIM := DTFIM;
      END IF;
    END IF;
    RETORNO := TIMEDIFF(DATACALCFIM,DATACALCINI);
    ELSE
        /*-->> MÉTODO PARA CÁLCULO DE HORAS*/
        -- SOMA HORAS FINAIS DO PRIMEIRO DIA
        HORAINIACUMULADA := (TO_CHAR(DTINI,'HH24') * 3600) + (TO_CHAR(DTINI,'MI') * 60) + TO_CHAR(DTINI,'SS');
        DATACALCFIM := TO_DATE((TO_CHAR(DTINI,'YYYY')||'-'||TO_CHAR(DTINI,'MM')||'-'||TO_CHAR(DTINI,'DD')||' '||FIMTURNO), 'YYYY-MM-DD HH24:MI:SS');
        HORAFIMACUMULADA := (TO_CHAR(DATACALCFIM,'HH24') * 3600) + (TO_CHAR(DATACALCFIM,'MI') * 60) + TO_CHAR(DATACALCFIM,'SS');
        SUMHORAS := HORAFIMACUMULADA - HORAINIACUMULADA;
       
        ICOUNT := 1;
        COUNTDIAS := ABS(DATEDIFF(DTFIM,DTINI));
      WHILE (ICOUNT <= COUNTDIAS)
      LOOP
          DATAPROXIMA := (DTINI + ICOUNT);
            -- VERIRICAR SE A PROXIMA DATA EH IGUAL A DATA FIM
            IF (TO_CHAR(DATAPROXIMA,'YYYY-MM-DD')=TO_CHAR(DTFIM,'YYYY-MM-DD')) THEN
              DATACALCINI := TO_DATE((TO_CHAR(DATAPROXIMA,'YYYY')||'-'||TO_CHAR(DATAPROXIMA,'MM')||'-'||TO_CHAR(DATAPROXIMA,'DD')||' '||INITURNO), 'YYYY-MM-DD HH24:MI:SS');
                HORAINIACUMULADA := (TO_CHAR(DATACALCINI,'HH24') * 3600) + (TO_CHAR(DATACALCINI,'MI') * 60) + TO_CHAR(DATACALCINI,'SS');
                HORAFIMACUMULADA := (TO_CHAR(DTFIM,'HH24') * 3600) + (TO_CHAR(DTFIM,'MI') * 60) + TO_CHAR(DTFIM,'SS');
                SUMHORAS := SUMHORAS + (HORAFIMACUMULADA - HORAINIACUMULADA);
            ELSE
                -- VERIFICAR FDS
                IF (TO_CHAR(DATAPROXIMA,'D')<>1 AND TO_CHAR(DATAPROXIMA,'D')<>7) THEN
                -- VERIFICAR FERIADO
                SELECT COUNT(*) INTO ISELECT FROM FKS_FERIADOS WHERE TO_CHAR(DT_FERIADO,'YYYY-MM-DD') = TO_CHAR(DATAPROXIMA,'YYYY-MM-DD');
                  IF (ISELECT <= 0) THEN
                        DATACALCINI := TO_DATE(TO_CHAR(DATAPROXIMA,'YYYY')||'-'||TO_CHAR(DATAPROXIMA,'MM')||'-'||TO_CHAR(DATAPROXIMA,'DD')||' '||INITURNO, 'YYYY-MM-DD HH24:MI:SS');
                        DATACALCFIM := TO_DATE(TO_CHAR(DATAPROXIMA,'YYYY')||'-'||TO_CHAR(DATAPROXIMA,'MM')||'-'||TO_CHAR(DATAPROXIMA,'DD')||' '||FIMTURNO, 'YYYY-MM-DD HH24:MI:SS');
                        HORAINIACUMULADA := (TO_CHAR(DATACALCINI,'HH24') * 3600) + (TO_CHAR(DATACALCINI,'MI') * 60) + TO_CHAR(DATACALCINI,'SS');
                        HORAFIMACUMULADA := (TO_CHAR(DATACALCFIM,'HH24') * 3600) + (TO_CHAR(DATACALCFIM,'MI') * 60) + TO_CHAR(DATACALCFIM,'SS');
                        SUMHORAS := SUMHORAS + (HORAFIMACUMULADA - HORAINIACUMULADA);
                    END IF;
                END IF;
            END IF;
            ICOUNT := ICOUNT + 1;
        END LOOP;
 
      /*-->> MÉTODO PARA CÁLCULO DE HORAS*/
        HORACALC := (FLOOR(SUMHORAS / 3600) );
        SUMHORAS := SUMHORAS - (HORACALC * 3600);
        MINUTOCALC := (FLOOR(SUMHORAS / 60) );
        SUMHORAS := SUMHORAS - (MINUTOCALC * 60);
        SEGUNDOCALC := SUMHORAS;
        -- SET RETORNO = CAST(CONCAT(HORACALC,':',MINUTOCALC,':',SEGUNDOCALC) AS TIME);
        RETORNO := LPAD(HORACALC,2,'0')||':'||LPAD(MINUTOCALC,2,'0')||':'||LPAD(SEGUNDOCALC,2,'0');
  END IF;
  RETURN RETORNO;
  EXCEPTION WHEN OTHERS THEN RETURN '00:00:00';
END;

CREATE OR REPLACE FUNCTION otrs_db.FNCTEMPOEMABERTO(IDTICKET INTEGER) RETURN VARCHAR  IS
  /* CRIANDO VARIAVEIS DO LOOP */
  HISTORYID INTEGER;
  STATEID INTEGER;
  QUEUEID INTEGER;
  CALENDARID INTEGER;
  HISTORYCREATETIME DATE;
  HISTORYCHANGETIME DATE;
  TEMPOTOTAL INTEGER;

  HISTORYIDOLD INTEGER;
  STATEIDOLD INTEGER;
  QUEUEIDOLD INTEGER;
  HISTORYCREATETIMEOLD DATE;
  HISTORYCHANGETIMEOLD DATE;
  /* CRIANDO CURSOR PARA O LOOP */
  CURSOR CRHISTORY_TICKET IS
  SELECT 
        TH.ID AS HISTORY_ID,
    COALESCE(S.CALENDAR_NAME,'1') AS CALENDAR_ID,
        TH.STATE_ID, 
        TH.QUEUE_ID,
        TH.CREATE_TIME AS HISTORY_CREATE_TIME,
        TH.CHANGE_TIME AS HISTORY_CHANGE_TIME
   FROM TICKET_HISTORY TH
   JOIN TICKET T ON TH.TICKET_ID = T.ID
   LEFT JOIN SLA S ON T.SLA_ID = S.ID
  WHERE 1 = 1
    AND TH.TICKET_ID = IDTICKET
    AND HISTORY_TYPE_ID IN (1,27)
  ORDER BY TH.ID;
BEGIN
  /* INICIALIZANDO VARIAVEIS */
  TEMPOTOTAL := 0;
  HISTORYIDOLD := 0;
  STATEIDOLD := 0;
  QUEUEIDOLD := 0;
  HISTORYCREATETIMEOLD := SYSDATE;
  HISTORYCHANGETIMEOLD := SYSDATE;

  OPEN CRHISTORY_TICKET;

  -- LOOP
  LOOP 
      -- OBTEM OS VALORES DA LINHA
      FETCH CRHISTORY_TICKET INTO HISTORYID, CALENDARID, STATEID, QUEUEID, HISTORYCREATETIME, HISTORYCHANGETIME;

      EXIT WHEN CRHISTORY_TICKET%NOTFOUND;
      
      IF (STATEIDOLD IN (1,4,5)) THEN
         -- SOMA TEMPO
         TEMPOTOTAL := TEMPOTOTAL + FNCTIME2TOINT(FNCTOTALHORASUTEIS(CALENDARID,HISTORYCREATETIMEOLD, HISTORYCREATETIME));
      END IF;
      -- REINICIA AS VARIAVEIS DO PROXIMO REGISTRO
      HISTORYCREATETIMEOLD := HISTORYCREATETIME;
      HISTORYCHANGETIMEOLD := HISTORYCHANGETIME;
      STATEIDOLD := STATEID; 
      QUEUEIDOLD := QUEUEID; 
  END LOOP;

  CLOSE CRHISTORY_TICKET;
  
  RETURN FNCINTTOTIME(TEMPOTOTAL);
END;

CREATE OR REPLACE FUNCTION otrs_db.FNCTEMPOPENDENTE(IDTICKET INTEGER) RETURN VARCHAR IS
  HISTORYID INTEGER;
  STATEID INTEGER;
  QUEUEID INTEGER;
  CALENDARID INTEGER;
  HISTORYCREATETIME DATE;
  HISTORYCHANGETIME DATE;
  TEMPOTOTAL INTEGER;
  HISTORYIDOLD INTEGER;
  STATEIDOLD INTEGER;
  QUEUEIDOLD INTEGER;
  HISTORYCREATETIMEOLD DATE;
  HISTORYCHANGETIMEOLD DATE;
  /* CRIANDO CURSOR PARA O LOOP */
  CURSOR CRHISTORY_TICKET IS
  SELECT
        TH.ID AS HISTORY_ID,
    COALESCE(S.CALENDAR_NAME,'9') AS CALENDAR_ID,
        TH.STATE_ID,
        TH.QUEUE_ID,
        TH.CREATE_TIME AS HISTORY_CREATE_TIME,
        TH.CHANGE_TIME AS HISTORY_CHANGE_TIME
   FROM TICKET_HISTORY TH
   JOIN TICKET T ON TH.TICKET_ID = T.ID
   LEFT JOIN SLA S ON T.SLA_ID = S.ID
  WHERE 1 = 1
    AND TH.TICKET_ID = IDTICKET
    AND HISTORY_TYPE_ID IN (1,16,27)
  ORDER BY TH.ID;
-- COMMENT 'RETORNA O TEMPO TOTAL DE PENDENCIA DO TICKET'
BEGIN
  /* INICIALIZANDO VARIAVEIS */
  TEMPOTOTAL := 0;
  HISTORYIDOLD := 0;
  STATEIDOLD := 0;
  QUEUEIDOLD := 0;
  HISTORYCREATETIMEOLD := SYSDATE;
  HISTORYCHANGETIMEOLD := SYSDATE;
 
  OPEN CRHISTORY_TICKET;
 
  -- LOOP
  LOOP
      -- OBTEM OS VALORES DA LINHA
      FETCH CRHISTORY_TICKET INTO HISTORYID, CALENDARID, STATEID, QUEUEID, HISTORYCREATETIME, HISTORYCHANGETIME;
 
      EXIT WHEN CRHISTORY_TICKET%NOTFOUND;
     
      IF (STATEIDOLD = 6) THEN
         -- SOMA TEMPO
         TEMPOTOTAL := TEMPOTOTAL + FNCTIME2TOINT(FNCTOTALHORASUTEIS(CALENDARID, HISTORYCREATETIMEOLD, HISTORYCREATETIME));
     -- SET TEMPOTOTAL = TEMPOTOTAL;
      END IF;
      -- REINICIA AS VARIAVEIS DO PROXIMO REGISTRO
      HISTORYCREATETIMEOLD := HISTORYCREATETIME;
      HISTORYCHANGETIMEOLD := HISTORYCHANGETIME;
      STATEIDOLD := STATEID;
      QUEUEIDOLD := QUEUEID;
  END LOOP;
 
  CLOSE CRHISTORY_TICKET;
 
  RETURN FNCINTTOTIME(TEMPOTOTAL);
END;
 
CREATE OR REPLACE FUNCTION otrs_db.FNCTEMPOPENDENTENAFILA(IDTICKET INTEGER, IDFILA INTEGER) RETURN VARCHAR IS
  HISTORYID INTEGER;
  STATEID INTEGER;
  QUEUEID INTEGER;
  CALENDARID INTEGER;
  HISTORYCREATETIME DATE;
  HISTORYCHANGETIME DATE;
  TEMPOTOTAL INTEGER;
 
  HISTORYIDOLD INTEGER;
  STATEIDOLD INTEGER;
  QUEUEIDOLD INTEGER;
  HISTORYCREATETIMEOLD DATE;
  HISTORYCHANGETIMEOLD DATE;
  /* CRIANDO CURSOR PARA O LOOP */
  CURSOR CRHISTORY_TICKET IS
  SELECT
        TH.ID AS HISTORY_ID,
    COALESCE(S.CALENDAR_NAME,'9') AS CALENDAR_ID,
        TH.STATE_ID,
        TH.QUEUE_ID,
        TH.CREATE_TIME AS HISTORY_CREATE_TIME,
        TH.CHANGE_TIME AS HISTORY_CHANGE_TIME
   FROM TICKET_HISTORY TH
   JOIN TICKET T ON TH.TICKET_ID = T.ID
   LEFT JOIN SLA S ON T.SLA_ID = S.ID
  WHERE 1 = 1
    AND TH.TICKET_ID = IDTICKET
    AND HISTORY_TYPE_ID IN (1,16,27)
  ORDER BY TH.ID;
 
BEGIN
  /* INICIALIZANDO VARIAVEIS */
  TEMPOTOTAL := 0;
  HISTORYIDOLD := 0;
  STATEIDOLD := 0;
  QUEUEIDOLD := 0;
  HISTORYCREATETIMEOLD := SYSDATE;
  HISTORYCHANGETIMEOLD := SYSDATE;
 
  OPEN CRHISTORY_TICKET;
 
  -- LOOP
  LOOP
      -- OBTEM OS VALORES DA LINHA
      FETCH CRHISTORY_TICKET INTO HISTORYID, CALENDARID, STATEID, QUEUEID, HISTORYCREATETIME, HISTORYCHANGETIME;
 
      EXIT WHEN CRHISTORY_TICKET%NOTFOUND;
     
      IF ( (STATEIDOLD = 6) AND (QUEUEIDOLD = IDFILA) ) THEN
         -- SOMA TEMPO
         TEMPOTOTAL := TEMPOTOTAL + FNCTIME2TOINT(FNCTOTALHORASUTEIS(CALENDARID, HISTORYCREATETIMEOLD, HISTORYCREATETIME));
     -- SET TEMPOTOTAL = TEMPOTOTAL;
      END IF;
      -- REINICIA AS VARIAVEIS DO PROXIMO REGISTRO
      HISTORYCREATETIMEOLD := HISTORYCREATETIME;
      HISTORYCHANGETIMEOLD := HISTORYCHANGETIME;
      STATEIDOLD := STATEID;
      QUEUEIDOLD := QUEUEID;
  END LOOP;
 
  CLOSE CRHISTORY_TICKET;
 
  RETURN FNCINTTOTIME(TEMPOTOTAL);
END;
 
CREATE OR REPLACE FUNCTION otrs_db.FNCTEMPONAFILA(IDTICKET INTEGER, IDFILA INTEGER) RETURN VARCHAR IS
  HISTORYID INTEGER;
  CALENDARID INTEGER;
  STATEID INTEGER;
  QUEUEID INTEGER;
  HISTORYCREATETIME DATE;
  HISTORYCHANGETIME DATE;
  TEMPOTOTAL INTEGER;
 
  HISTORYIDOLD INTEGER;
  STATEIDOLD INTEGER;
  QUEUEIDOLD INTEGER;
  HISTORYCREATETIMEOLD DATE;
  HISTORYCHANGETIMEOLD DATE;
  /* CRIANDO CURSOR PARA O LOOP */
  CURSOR CRHISTORY_TICKET IS
  SELECT
        TH.ID AS HISTORY_ID,
        COALESCE(S.CALENDAR_NAME,'9') AS CALENDAR_ID,
        TH.STATE_ID,
        TH.QUEUE_ID,
        TH.CREATE_TIME AS HISTORY_CREATE_TIME,
        TH.CHANGE_TIME AS HISTORY_CHANGE_TIME
   FROM TICKET_HISTORY TH
   JOIN TICKET T ON TH.TICKET_ID = T.ID
   LEFT JOIN SLA S ON T.SLA_ID = S.ID
  WHERE 1 = 1
    AND TH.TICKET_ID = IDTICKET
    AND HISTORY_TYPE_ID IN (1,16,27)
  ORDER BY TH.ID;
 
BEGIN
  /* INICIALIZANDO VARIAVEIS */
  TEMPOTOTAL := 0;
  HISTORYIDOLD := 0;
  STATEIDOLD := 0;
  QUEUEIDOLD := 0;
  HISTORYCREATETIMEOLD := SYSDATE;
  HISTORYCHANGETIMEOLD := SYSDATE;
 
  OPEN CRHISTORY_TICKET;
 
  -- LOOP
  LOOP
      -- OBTEM OS VALORES DA LINHA
      FETCH CRHISTORY_TICKET INTO HISTORYID, CALENDARID, STATEID, QUEUEID, HISTORYCREATETIME, HISTORYCHANGETIME;
 
      EXIT WHEN CRHISTORY_TICKET%NOTFOUND;
     
      --IF (QUEUEIDOLD = IDFILA) AND (STATEIDOLD IN (1,4,17,18,19,23)) THEN
      IF (QUEUEIDOLD = IDFILA) THEN
         -- SOMA TEMPO
         TEMPOTOTAL := TEMPOTOTAL + FNCTIME2TOINT(FNCTOTALHORASUTEIS(CALENDARID,HISTORYCREATETIMEOLD, HISTORYCREATETIME));
      END IF;
      -- REINICIA AS VARIAVEIS DO PROXIMO REGISTRO
      HISTORYCREATETIMEOLD := HISTORYCREATETIME;
      HISTORYCHANGETIMEOLD := HISTORYCHANGETIME;
      STATEIDOLD := STATEID;
      QUEUEIDOLD := QUEUEID;
  END LOOP;
 
  CLOSE CRHISTORY_TICKET;
 
  RETURN FNCINTTOTIME(TEMPOTOTAL);
END;
 
-- 
-- Visões
create or replace view otrs_db.vw_last_closed as
    select
        ticket_history.ticket_id as ticket_id,
        max(ticket_history.id) as history_id
    from ticket_history
    where ticket_history.history_type_id = 27
    -- and ticket_history.queue_id <> 35
  and ticket_history.state_id in (select id from ticket_state where type_id = 3)
    group by ticket_history.ticket_id
;
create or replace view otrs_db.vw_first_article as
    select
        a.ticket_id as ticket_id,
        cc.id as communication_channel_id, cc.name as communication_channel,
        min(a.id) as article_id
    from article a
    join communication_channel cc on a.communication_channel_id = cc.id
    group by a.ticket_id, cc.id, cc.name
;
create or replace view vw_comm_channel as
select
        fa.ticket_id, fa.article_id, cc.id as communication_channel_id, cc.name as communication_channel
    from vw_first_article fa 
    join article a on fa.article_id = a.id
    join communication_channel cc on a.communication_channel_id = cc.id
;
create or replace view otrs_db.vw_first_history as
select min(th.id) as history_id, th.ticket_id
  from ticket_history th
group by th.ticket_id
;
create or replace view otrs_db.vw_first_move as
select min(th.id) as history_id, th.ticket_id
  from ticket_history th
where history_type_id = 16
group by th.ticket_id
;
create or replace view otrs_db.vw_qtd_move as
select ticket_id, count(id) as qtd_move
from ticket_history
where history_type_id = 16
-- and queue_id not in (23,35)
group by ticket_id
;
create or replace view otrs_db.vw_last_state_history as
    select
        th.ticket_id as ticket_id,
        max(th.id) as history_id
    from ticket_history th
    where th.history_type_id = 27
    group by th.ticket_id
;
create or replace view otrs_db.vw_all_tickets_finish as
    select
        max(th.id) as history_id,
        th.ticket_id as ticket_id
    from ticket_history th
    WHERE th.history_type_id = 27
      and th.state_id in (select id from ticket_state where type_id in (3)) -- closed
    group by th.ticket_id
;
 
create or replace view otrs_db.vw_bypass_cs as
select min(id) as history_id, ticket_id
from ticket_history
where history_type_id in (1,16)
and queue_id in (select id from queue where upper(name) like 'CENTRAL%')
group by ticket_id
;
 
create or replace view otrs_db.vw_first_contact as
select min(id) as history_id, ticket_id
from ticket_history
where history_type_id in (14) -- PhoneCallCustomer
group by ticket_id
;
-- Primeiro contato via telefone
create or replace view otrs_db.vw_tempo_resposta as
select fc.history_id, fc.ticket_id, th.create_time as time_response
from vw_first_contact fc
join ticket_history th on fc.history_id = th.id
where 1=1
;
 
create or replace view otrs_db.vw_start_attend as
select min(id) as history_id, ticket_id
from ticket_history
where history_type_id in (27) -- StateUpdate
and state_id = (select id from ticket_state where upper(name) like 'EM%ANDAMENTO%') -- In attendance
group by ticket_id
;
-- Início tratamento Equipe
create or replace view otrs_db.vw_tempo_atendimento as
select sa.history_id, sa.ticket_id, th.create_time as time_attend
from vw_start_attend sa
join ticket_history th on sa.history_id = th.id
where 1=1
;
 
create or replace view otrs_db.vw_tickets_encerrados as
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
create or replace view otrs_db.vw_kpi as
select
t.id as ticket_id, t.tn, t.title, t.create_time,
tt.id as type_id, tt.name as type_name,
tp.id as priority_id, tp.name as priority_name,
ts.id as state_id, ts.name as state_name,
s.id as service_id, s.name as service_name,
te.queue_create, q1.name as queue_create_name,
te.queue_finish, q2.name as queue_finish_name,
te.finish_time,
te.user_finish as user_finish_id, (u.first_name||' '||u.last_name) as user_finish,
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
create or replace view otrs_db.vw_kpi_stats as
select
kpi.*
,case when kpi.time_response > kpi.first_response_time then 1 else 0 end sla_response_violate
,case when (kpi.time_solution - kpi.time_pending) > kpi.solution_time then 1 else 0 end sla_solution_violate
from vw_kpi kpi
where 1=1
;
 
--
create or replace view otrs_db.vw_kpi_pqs as
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
, case when to_char(sv.vote_value) in ('1','2','5','6','9','10','13','14') then '1' else null end as satisfaction
, case when to_char(sv.vote_value) in ('4','8','12','16') then '1' else null end as nosatisfaction
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
left join survey_answer sa on to_char(sv.vote_value) = to_char(sa.id)
left join service srv on t.service_id = srv.id
where 1=1
and s.status = 'Master'
order by sr.ticket_id, sq.position
;
 
--
create or replace view otrs_db.vw_survey_questions as
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
create or replace view otrs_db.vw_survey_answers_textarea as
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
create or replace view otrs_db.vw_survey_answers as
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
left join survey_vote sv on to_char(sa.id) = to_char(sv.vote_value)
left join vw_survey_answers_textarea sat on sq.id = sat.question_id
group by sq.id , sq.question , sq.position , sa.id , sa.answer , sa.position , coalesce(cast(sv.create_time as date),sat.date_vote)
order by sq.position , sa.position
;
 
--
create or replace view otrs_db.vw_notify_resolution as
select distinct a.ticket_id
from article a
join article_data_mime adm on a.id = adm.article_id
where 1=1
and adm.a_subject LIKE '%Resolução do Chamado%'
;
 
--
create or replace view otrs_db.vw_kpi_notificacao as
select
kpi.*
from vw_kpi kpi
where kpi.ticket_id not in (select ticket_id from vw_notify_resolution)
;
 
--
create or replace view otrs_db.vw_reopen as
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
create or replace view otrs_db.vw_tickets_reabertos as
select
kpi.*
from vw_kpi kpi
where kpi.ticket_id in (select ticket_id from vw_reopen)
;
--
create or replace view otrs_db.vw_tickets_ola_sub as
select min(th.id) as history_id, th.ticket_id
    from ticket_history th
   where history_type_id = 16 -- move
--       and queue_id = 27
   group by th.ticket_id
;
--
-- Tempo encaminhamento OLA
create or replace view otrs_db.vw_tickets_ola as
select
kpi.*,
th.change_time as move_ola,
fncTotalHorasUteis(1,kpi.create_time,th.change_time) as time_move_ola
from vw_kpi kpi
join vw_tickets_ola_sub ola on kpi.ticket_id = ola.ticket_id
join ticket_history th on ola.history_id = th.id
;
 
--
create or replace view otrs_db.vw_user_role as
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
create or replace view otrs_db.vw_sla_fulfill as
select
*
from vw_kpi
where 1=1
and (time_solution - time_pending) <= 14400
;
 
--
create or replace view otrs_db.vw_sla_violate as
select
*
from vw_kpi
where 1=1
and (time_solution - time_pending) > 14400
;
 
--
create or replace view otrs_db.vw_ticket_ci AS
select t.id as ticket_id, t.tn,
lr.*
from link_relation lr
join ticket t on lr.source_key = t.id and lr.source_object_id = 1
join configitem ci on lr.target_key = ci.id and lr.target_object_id = 2
;
 
--
create or replace view otrs_db.vw_ticket_stat_general as
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
CREATE OR REPLACE VIEW VW_KPI_TICKETS AS
SELECT 
  T.ID AS TICKET_ID,
  T.TN AS TN,
  T.CREATE_TIME AS CREATE_TIME,
  T.TITLE AS TITLE,
  TS.NAME AS STATE_NAME,
  TT.NAME AS TYPE_NAME,
  TP.NAME AS PRIRITY_NAME,
  Q1.NAME AS QUEUE_CREATE,
  Q3.NAME AS QUEUE_ACTUAL,
  Q2.NAME AS QUEUE_FINISH,
  TE.FINISH_TIME AS FINISH_TIME,
  (U.FIRST_NAME||' '||U.LAST_NAME) AS USER_FINISH,
  (U2.FIRST_NAME||' '||U2.LAST_NAME) AS USER_CREATE,
  FA.COMMUNICATION_CHANNEL,
  T.SERVICE_ID AS SERVICE_ID,
  S.NAME AS SERVICE_NAME,
  T.SLA_ID AS SLA_ID,
  SLA.NAME AS SLA_NAME,
  SLA.CALENDAR_NAME AS SLA_ID_CALENDAR,
  REPLACE(SUBSTR(SLA.COMMENTS,1,INSTR(SLA.COMMENTS,';')-1),'UST=') AS SLA_UST, 
  REPLACE(SUBSTR(SLA.COMMENTS,INSTR(SLA.COMMENTS,';')+1,LENGTH(SLA.COMMENTS)),'VLR=') AS SLA_UST_VLR,
  otrs_db.FNCINTTOTIME(SLA.FIRST_RESPONSE_TIME * 60) AS SLA_RESPONSE_TIME,
  otrs_db.FNCINTTOTIME(SLA.SOLUTION_TIME * 60) AS SLA_SOLUTION_TIME,
  otrs_db.FNCTEMPOEMABERTO(T.ID) AS TIME_OPENED,
  otrs_db.FNCTEMPOPENDENTE(T.ID) AS TIME_PENDING,
  otrs_db.FNCTOTALHORASUTEIS(SLA.CALENDAR_NAME,T.CREATE_TIME,TE.FINISH_TIME) AS TIME_SOLUTION,
  CASE WHEN (otrs_db.FNCTIME2TOINT(otrs_db.FNCTOTALHORASUTEIS(SLA.CALENDAR_NAME,T.CREATE_TIME,TE.FINISH_TIME)) - otrs_db.FNCTIME2TOINT(otrs_db.FNCTEMPOPENDENTE(T.ID))) <= (SLA.SOLUTION_TIME * 60)
    THEN
      'TRUE'
    ELSE 
      CASE WHEN (COALESCE(SLA.SOLUTION_TIME, 0) * 60) = 0 THEN 'TRUE' ELSE 'FALSE' END
  END AS SLA_ATTEND,
  COALESCE(T.CUSTOMER_ID, '') AS CUSTOMER_ID,
  T.CUSTOMER_USER_ID AS CUSTOMER_USER_ID
FROM otrs_db.VW_TICKETS_ENCERRADOS TE
JOIN otrs_db.TICKET T ON TE.TICKET_ID = T.ID 
JOIN otrs_db.TICKET_TYPE TT ON T.TYPE_ID = TT.ID
JOIN otrs_db.TICKET_PRIORITY TP ON T.TICKET_PRIORITY_ID = TP.ID
JOIN otrs_db.TICKET_STATE TS ON T.TICKET_STATE_ID = TS.ID
JOIN otrs_db.VW_FIRST_HISTORY FH ON T.ID = FH.TICKET_ID
JOIN otrs_db.TICKET_HISTORY THF ON THF.ID = FH.HISTORY_ID
JOIN otrs_db.QUEUE Q3 ON T.QUEUE_ID = Q3.ID
JOIN otrs_db.VW_COMM_CHANNEL FA ON T.ID = FA.TICKET_ID
LEFT JOIN otrs_db.QUEUE Q1 ON THF.QUEUE_ID = Q1.ID
LEFT JOIN otrs_db.QUEUE Q2 ON TE.QUEUE_FINISH = Q2.ID
LEFT JOIN otrs_db.USERS U ON TE.USER_FINISH = U.ID
LEFT JOIN otrs_db.USERS U1 ON T.CHANGE_BY = U1.ID
LEFT JOIN otrs_db.USERS U2 ON T.CREATE_BY = U2.ID
LEFT JOIN otrs_db.SERVICE S ON T.SERVICE_ID = S.ID
LEFT JOIN otrs_db.SLA ON T.SLA_ID = SLA.ID
WHERE 1 = 1
;