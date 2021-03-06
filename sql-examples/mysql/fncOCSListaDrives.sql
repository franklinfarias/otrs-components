
DROP FUNCTION IF EXISTS ocsweb.fnc_ocs_lista_drives;
CREATE FUNCTION ocsweb.fnc_ocs_lista_drives(hardware_id INT)
	RETURNS VARCHAR(800)
BEGIN
	DECLARE DLetter VARCHAR(255);
    DECLARE DType VARCHAR(255);
    DECLARE DFileSystem VARCHAR(255);
    DECLARE DTotal INT(11);
    DECLARE Listagem VARCHAR(800);
    
    DECLARE crDRIVES CURSOR FOR 
    	SELECT d.letter, d.type, d.filesystem, d.total
          FROM drives d
          JOIN hardware h ON d.hardware_id = h.id
         WHERE h.id = hardware_id;
    DECLARE EXIT HANDLER FOR NOT FOUND BEGIN END;
    SET DLetter = "";
    SET DType = "";
    SET DFileSystem = "";
    SET DTotal = 0;
    SET Listagem = "DType";
    OPEN crDRIVES;
    
    LOOP 
    	FETCH crDRIVES INTO DLetter, DType, DFileSystem, DTotal;
        SET Listagem = CONCAT(Listagem, DType, '(', DLetter, COALESCE(DFileSystem,'-'), ':', COALESCE(DTotal,'0'), ') ');
        
    END LOOP;
    CLOSE crDRIVES;
    RETURN Listagem;
END;