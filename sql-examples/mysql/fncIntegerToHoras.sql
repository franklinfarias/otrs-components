USE `otrs`;
DROP function IF EXISTS `fncIntegerToHoras`;

DELIMITER $$
USE `otrs`$$
CREATE FUNCTION `fncIntegerToHoras` (dtData INTEGER)
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

