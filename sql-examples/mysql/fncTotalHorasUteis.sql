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

