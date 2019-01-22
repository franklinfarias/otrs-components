CREATE OR REPLACE FUNCTION OTRS.FNCHOURTOINTEGER(DTDATA DATE) RETURN INTEGER
DETERMINISTIC IS SUMHORAS integer; HORACALC integer; MINUTOCALC integer; SEGUNDOCALC integer;
BEGIN
    RETURN (to_char(dtData,'HH24') * 3600) + (to_char(dtData,'MI') * 60) + to_char(dtData,'SS');
END;