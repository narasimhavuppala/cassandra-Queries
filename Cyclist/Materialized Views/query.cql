// Base Tables
CREATE TABLE IF NOT EXISTS cycling.cyclist_mv (
	cid UUID PRIMARY KEY,
	name text,
	age int,
	birthday date,
	country text
);

INSERT INTO cycling.cyclist_mv ( cid, name, age, birthday, country )
VALUES ( e7ae5cf3-d358-4d99-b900-85902fda9bb0, 'Alex FRAME', 22, '1993-06-18', 'New Zealand' );

INSERT INTO cycling.cyclist_mv ( cid, name, age, birthday, country )
VALUES ( 220844bf-4860-49d6-9a4b-6b5d3a79cbfb, 'Paolo TIRALONGO', 38, '1977-07-08', 'Italy' );

INSERT INTO cycling.cyclist_mv ( cid, name, age, birthday, country )
VALUES ( 6ab09bec-e68e-48d9-a5f8-97e6fb4c9b47, 'Steven KRUIKSWIJK', 28, '1987-06-07', 'Netherlands' );

INSERT INTO cycling.cyclist_mv ( cid, name, age, birthday, country )
VALUES ( ffdfa2a7-5fc6-49a7-bfdc-3fcdcfdd7156, 'Pascal EENKHOORN', 18, '1997-02-08', 'Netherlands' );

INSERT INTO cycling.cyclist_mv ( cid, name, age, birthday, country )
VALUES ( 18f471bf-f631-4bc4-a9a2-d6f6cf5ea503, 'Bram WELTEN', 18, '1997-03-29', 'Netherlands' );

INSERT INTO cycling.cyclist_mv ( cid, name, age, birthday, country )
VALUES ( 15a116fc-b833-4da6-ab9a-4a7775752836, 'Adrien COSTA', 18, '1997-08-19', 'United States' );

INSERT INTO cycling.cyclist_mv ( cid, name, age, birthday, country )
VALUES ( 862cc51f-00a1-4d5a-976b-a359cab7300e, 'Joakim BUKDAL', 20, '1994-09-04', 'Denmark' );

INSERT INTO cycling.cyclist_mv ( cid, name, age, birthday, country )
VALUES ( c9c9c484-5e4a-4542-8203-8d047a01b8a8, 'Cristian EGIDIO', 27, '1987-09-04', 'Brazil' );

INSERT INTO cycling.cyclist_mv ( cid, name, age, birthday, country )
VALUES ( d1aad83b-be60-47a4-bd6e-069b8da0d97b, 'Johannes HEIDER', 27, '1987-09-04', 'Germany' );

CREATE MATERIALIZED VIEW IF NOT EXISTS cycling.cyclist_by_age AS
	SELECT age, birthday, name, country
	FROM cyclist_mv
	WHERE age is NOT NULL AND cid IS NOT NULL
	PRIMARY KEY ( age, cid );

CREATE MATERIALIZED VIEW IF NOT EXISTS cycling.cyclist_by_country AS
	SELECT age, birthday, name, country
	FROM cyclist_mv
	WHERE country is NOT NULL AND cid IS NOT NULL
	PRIMARY KEY ( country, cid );

CREATE MATERIALIZED VIEW IF NOT EXISTS cycling.cyclist_by_birthday AS
	SELECT age, birthday, name, country
	FROM cyclist_mv
	WHERE birthday is NOT NULL AND cid IS NOT NULL
	PRIMARY KEY ( birthday, cid );
	
	
	
	
	SELECT age, name, birthday FROM cycling.cyclist_by_age WHERE age = 18;
    SELECT age, name, birthday FROM cycling.cyclist_by_country WHERE country = 'Netherlands';
    SELECT age, name, birthday FROM cycling.cyclist_by_birthday WHERE birthday = '1987-09-04';
    DROP MATERIALIZED VIEW IF  EXISTS  cycling.cyclist_by_age;