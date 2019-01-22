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

