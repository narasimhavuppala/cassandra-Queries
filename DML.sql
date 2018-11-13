CREATE KEYSPACE test WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '2'}  AND durable_writes = true;

select * from  test.user;
delete from test.user where id='two';

update test.user set emnail='all@man.com',name='all' where id='all';
insert into test.user(id,emnail,name) values('all','','');

select * from test.user where id='test';
