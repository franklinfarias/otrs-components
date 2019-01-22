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

