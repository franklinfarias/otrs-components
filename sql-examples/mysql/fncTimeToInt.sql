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

