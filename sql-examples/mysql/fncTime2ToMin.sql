USE `otrs`;
DROP function IF EXISTS `fncTime2ToMin`;

DELIMITER $$
USE `otrs`$$
CREATE FUNCTION `fncTime2ToMin` (tTime time)
RETURNS INTEGER
BEGIN
	-- RETURN HOUR(tTime) * 60 + MINUTE(tTime) + SECOND(tTime) / 60;
	return floor(hour(tTime) * 60 + minute(tTime) + second(tTime) / 60);
END$$

DELIMITER ;

