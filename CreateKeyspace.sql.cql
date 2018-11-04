
CREATE KEYSPACE university
WITH durable_writes = true
AND replication = {
	'class' : 'SimpleStrategy',
	'replication_factor' : 3
};


CREATE TABLE Mapper
(id int primary key, 
name varchar
);
Insert into Mapper(id,name) values (6,'Narasimha');

select * from Mapper;
