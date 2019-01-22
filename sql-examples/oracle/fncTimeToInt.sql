-- ORACLE
CREATE FUNCTION fncTimeToInt(dtData DATE) RETURNS integer
BEGIN

	RETURN to_char(dtData,'HH24') * 3600 + to_char(dtData,'MI') * 60 + to_char(dtData,'SS');
END