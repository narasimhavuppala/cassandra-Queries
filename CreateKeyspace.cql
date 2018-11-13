 
CREATE KEYSPACE IF NOT EXISTS university
WITH durable_writes = true
AND replication = {
	'class' : 'SimpleStrategy',
	'replication_factor' : 2
};



DESCRIBE  university;

USE university;

--Altering replication factor

ALTER KEYSPACE keyspace_name 
WITH REPLICATION =  { 'class' : 'SimpleStrategy', 'replication_factor' : 3 };

nodetool repair --full keyspace_name



DROP KEYSPACE keyspace_name;


