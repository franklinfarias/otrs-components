USE `otrs`;
DROP function IF EXISTS `fncHorasToInteger`;

DELIMITER $$
USE `otrs`$$
CREATE FUNCTION `fncHorasToInteger` (dtData DATETIME)
RETURNS INTEGER
BEGIN
   RETURN ((HOUR(dtData) * 3600) + (MINUTE(dtData) * 60) + SECOND(dtData));
END$$

DELIMITER ;

