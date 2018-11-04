 
CREATE KEYSPACE IF NOT EXISTS university
WITH durable_writes = true
AND replication = {
	'class' : 'SimpleStrategy',
	'replication_factor' : 2
};



DESCRIBE  university;
