CALL Agencia('Decision in Normandy');

SELECT table_schema 'Agencia', SUM(data_length + index_length) / 1024 / 1024 'DB Size in MB'
	FROM information_schema.tables
	WHERE table_schema = 'Agencia';

SELECT TABLE_NAME, table_rows, data_length / 1024 'Dados (KB)', index_length / 1024 'Indices (KB)', 
round(((data_length + index_length) / 1024 / 1024),5) 'Size in MB'
	FROM information_schema.TABLES WHERE table_schema = 'Agencia';


