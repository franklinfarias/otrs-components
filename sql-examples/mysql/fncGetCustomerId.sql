DROP FUNCTION IF EXISTS fncGetCustomerID;

DELIMITER $$

CREATE DEFINER=`root`@`%` FUNCTION `fncGetCustomerID`(TicketID int) RETURNS VARCHAR(50)
BEGIN
	declare customerId varchar(255);

	select 
	case 
		when locate('PECOITS', t.title) > 0 then 'clinica.pecoits'
		when locate('ELETROGOMES', t.title) > 0 then 'eletrogomes'
		when locate('EXATA DIGITAL', t.title) > 0 then 'exata.impressao'
		when locate('FG', t.title) > 0 then 'fg.consultoria'
		when locate('CASABLANCA', t.title) > 0 then 'hotel.casablanca'
		when locate('IBORL', t.title) > 0 then 'iborl'
		when locate('PAPELARIA ABC', t.title) > 0 then 'papelaria.abc'
		when locate('SINDICONDOMINIO', t.title) > 0 then 'sindicondominio'
		when locate('VIVA PREVIDENCIA', t.title) > 0 then 'vivaprev'
		when locate('MEGATEAM', t.title) > 0 then 'megateam'
		when locate('TAREA', t.title) > 0 then 'tarea'
	else 'megateam'
	end as customer_id into customerId
	from ticket t
	where t.id = TicketID;
	
	return customerId;

END$$

DELIMITER ;