CREATE KEYSPACE IF NOT EXISTS cycling
WITH replication = {
	'class' : 'SimpleStrategy',
	'replication_factor' : 1
};

USE cycling;

/********************************* Q1:****************************************************/
// Find a cyclist's name given an ID number
// CREATE TABLE SIMPLE PRIMARY KEY
CREATE TABLE IF NOT EXISTS cycling.cyclist_name (
	id UUID PRIMARY KEY,
	lastname text,
	firstname text
);

INSERT INTO cycling.cyclist_name ( id, lastname, firstname )
VALUES ( 5b6962dd-3f90-4c93-8f61-eabfa4a803e2, 'VOS', 'Marianne' );

INSERT INTO cycling.cyclist_name ( id, lastname, firstname )
VALUES ( e7cd5752-bc0d-4157-a80f-7523add8dbcd, 'VAN DER BREGGEN', 'Anna' );

INSERT INTO cycling.cyclist_name ( id, lastname, firstname )
VALUES ( e7ae5cf3-d358-4d99-b900-85902fda9bb0, 'FRAME', 'Alex' );

INSERT INTO cycling.cyclist_name ( id, lastname, firstname )
VALUES ( 220844bf-4860-49d6-9a4b-6b5d3a79cbfb, 'TIRALONGO', 'Paolo' );

INSERT INTO cycling.cyclist_name ( id, lastname, firstname )
VALUES ( 6ab09bec-e68e-48d9-a5f8-97e6fb4c9b47, 'KRUIKSWIJK', 'Steven' );

INSERT INTO cycling.cyclist_name ( id, lastname, firstname )
VALUES ( fb372533-eb95-4bb4-8685-6ef61e994caa, 'MATTHEWS', 'Michael' );

select * from cycling.cyclist_name
where id = e7ae5cf3-d358-4d99-b900-85902fda9bb0;



/********************************* Q2:****************************************************/
// Find cyclists that fit a particular category
// CREATE TABLE CLUSTERING ORDER, PRIMARY KEY: PARTITION KEY + 1 CLUSTERING COLUMN, SIMPLE WHERE QUERY
CREATE TABLE IF NOT EXISTS cycling.cyclist_category (
	category text,
	points int,
	id UUID,
	lastname text,
	PRIMARY KEY (category, points)
) WITH CLUSTERING ORDER BY ( points DESC );

INSERT INTO cycling.cyclist_category ( category, points, id, lastname )
VALUES ( 'GC', 1269, 220844bf-4860-49d6-9a4b-6b5d3a79cbfb, 'TIRALONGO' );

INSERT INTO cycling.cyclist_category ( category, points, id, lastname )
VALUES ( 'One-day-races', 367, 220844bf-4860-49d6-9a4b-6b5d3a79cbfb, 'TIRALONGO' );

INSERT INTO cycling.cyclist_category ( category, points, id, lastname )
VALUES ( 'Time-trial', 182, 220844bf-4860-49d6-9a4b-6b5d3a79cbfb, 'TIRALONGO' );

INSERT INTO cycling.cyclist_category ( category, points, id, lastname )
VALUES ( 'Sprint', 0, 220844bf-4860-49d6-9a4b-6b5d3a79cbfb, 'TIRALONGO' );

INSERT INTO cycling.cyclist_category ( category, points, id, lastname )
VALUES ( 'GC', 1324, 6ab09bec-e68e-48d9-a5f8-97e6fb4c9b47, 'KRUIJSWIJK' );

INSERT INTO cycling.cyclist_category ( category, points, id, lastname )
VALUES ( 'One-day-races', 198, 6ab09bec-e68e-48d9-a5f8-97e6fb4c9b47, 'KRUIJSWIJK' );

INSERT INTO cycling.cyclist_category ( category, points, id, lastname )
VALUES ( 'Sprint', 39, 6ab09bec-e68e-48d9-a5f8-97e6fb4c9b47, 'KRUIJSWIJK' );

INSERT INTO cycling.cyclist_category ( category, points, id, lastname )
VALUES ( 'Time-trial', 3, 6ab09bec-e68e-48d9-a5f8-97e6fb4c9b47, 'KRUIJSWIJK' );

select * from cycling.cyclist_category
where category = 'One-day-races';






/********************************* Q3:****************************************************/
// Store race information by year and race name using a COMPOSITE PARTITION KEY
CREATE TABLE IF NOT EXISTS cycling.rank_by_year_and_name (
	race_year int,
	race_name text,
	cyclist_name text,
	rank int,
	PRIMARY KEY (( race_year, race_name ), rank)
);

INSERT INTO cycling.rank_by_year_and_name ( race_year, race_name, cyclist_name, rank )
VALUES ( 2015, 'Tour of Japan - Stage 4 - Minami > Shinshu', 'Benjamin PRADES', 1 );

INSERT INTO cycling.rank_by_year_and_name ( race_year, race_name, cyclist_name, rank )
VALUES ( 2015, 'Tour of Japan - Stage 4 - Minami > Shinshu', 'Adam PHELAN', 2 );

INSERT INTO cycling.rank_by_year_and_name ( race_year, race_name, cyclist_name, rank )
VALUES ( 2015, 'Tour of Japan - Stage 4 - Minami > Shinshu', 'Thomas LEBAS', 3 );

INSERT INTO cycling.rank_by_year_and_name ( race_year, race_name, cyclist_name, rank )
VALUES ( 2015, 'Giro d''Italia - Stage 11 - Forli > Imola', 'Ilnur ZAKARIN', 1 );

INSERT INTO cycling.rank_by_year_and_name ( race_year, race_name, cyclist_name, rank )
VALUES ( 2015, 'Giro d''Italia - Stage 11 - Forli > Imola', 'Carlos BETANCUR', 2 );

INSERT INTO cycling.rank_by_year_and_name ( race_year, race_name, cyclist_name, rank )
VALUES ( 2014, '4th Tour of Beijing', 'Phillippe GILBERT', 1 );

INSERT INTO cycling.rank_by_year_and_name ( race_year, race_name, cyclist_name, rank )
VALUES ( 2014, '4th Tour of Beijing', 'Daniel MARTIN', 2 );

INSERT INTO cycling.rank_by_year_and_name ( race_year, race_name, cyclist_name, rank )
VALUES ( 2014, '4th Tour of Beijing', 'Johan Esteban CHAVES', 3 );

select * from cycling.rank_by_year_and_name
where race_year = 2014 and race_name = '4th Tour of Beijing';

// New C* 3.6
// PER PARTITION LIMIT
// To get the Top Two for each race_year-race_name pair







/********************************* Q4:****************************************************/


// Find a cyclist's id given lastname and firstname.occasional indexes as well

CREATE TABLE IF NOT EXISTS cycling.cyclist_id (
	lastname text,
	firstname text,
	age int,
	id UUID,
	PRIMARY KEY (( lastname, firstname ), age)
);

INSERT INTO cycling.cyclist_id ( lastname, firstname, age, id )
VALUES ( 'EENKHOORN', 'Pascal', 18, ffdfa2a7-5fc6-49a7-bfdc-3fcdcfdd7156 );

INSERT INTO cycling.cyclist_id ( lastname, firstname, age, id )
VALUES ( 'WELTEN', 'Bram', 18, 18f471bf-f631-4bc4-a9a2-d6f6cf5ea503 );

INSERT INTO cycling.cyclist_id ( lastname, firstname, age, id )
VALUES ( 'COSTA', 'Adrien', 17, 15a116fc-b833-4da6-ab9a-4a7775752836 );

select * from cycling.cyclist_id
where firstname = 'Bram' and lastname = 'WELTEN';

// If you want to search by age, an index can be added
CREATE INDEX IF NOT EXISTS c_age ON cycling.cyclist_id (age);

select * from cycling.cyclist_id
where age = 18;




/********************************* Q5:****************************************************/


// Display flag for riders
// CREATE TABLE WITH STATIC COLUMN, example uses an integer to identify flag, but it could be a blob

CREATE TABLE IF NOT EXISTS cycling.country_flag (
	country text,
	cyclist_name text,
	flag int STATIC,
	PRIMARY KEY (country, cyclist_name)
);

INSERT INTO cycling.country_flag ( country, cyclist_name, flag )
VALUES ( 'Belgium', 'Jacques', 1 );

INSERT INTO cycling.country_flag ( country, cyclist_name )
VALUES ( 'Belgium', 'Andre' );

INSERT INTO cycling.country_flag ( country, cyclist_name, flag )
VALUES ( 'France', 'Andre', 2 );

INSERT INTO cycling.country_flag ( country, cyclist_name, flag )
VALUES ( 'France', 'George', 3 );

select * from cycling.country_flag;

// USE SELECT REPEATEDLY TO SHOW CHANGING (OR UNCHANGING) NATURE OF the column 'flag'



/********************************* Q6:****************************************************/



// Find all teams that a cyclist has been a member of


CREATE TABLE IF NOT EXISTS cycling.cyclist_career_teams (
	id UUID PRIMARY KEY,
	lastname text,
	teams set<text>);

INSERT INTO cycling.cyclist_career_teams ( id, lastname, teams )
VALUES ( 5b6962dd-3f90-4c93-8f61-eabfa4a803e2, 'VOS', { 'Rabobank-Liv Woman Cycling Team', 'Rabobank-Liv Giant',
'Rabobank Women Team', 'Nederland bloeit' } );

INSERT INTO cycling.cyclist_career_teams ( id, lastname, teams )
VALUES ( e7cd5752-bc0d-4157-a80f-7523add8dbcd, 'VAN DER BREGGEN', { 'Rabobank-Liv Woman Cycling Team',
'Sengers Ladies Cycling Team', 'Team Flexpoint' } );

INSERT INTO cycling.cyclist_career_teams ( id, lastname, teams )
VALUES ( cb07baad-eac8-4f65-b28a-bddc06a0de23, 'ARMITSTEAD', { 'Boels-Dolmans Cycling Team', 'AA Drink - Leontien.nl',
'Team Garmin - Cervelo' } );

INSERT INTO cycling.cyclist_career_teams ( id, lastname, teams )
VALUES ( 1c9ebc13-1eab-4ad5-be87-dce433216d40, 'BRAND', { 'Rabobank-Liv Woman Cycling Team', 'Rabobank-Liv Giant',
'AA Drink - Leontien.nl', 'Leontien.nl' } );

select * from cycling.cyclist_career_teams;

/********************************* Q7:****************************************************/


// NOT A QUERY, JUST A TABLE FOR QUERIES
// CREATE TABLE WITH LIST FOR UPDATE
CREATE TABLE IF NOT EXISTS cycling.calendar (
	race_id int,
	race_name text,
	race_start_date timestamp,
	race_end_date timestamp,
	PRIMARY KEY (race_id, race_start_date, race_end_date)
);

INSERT INTO cycling.calendar ( race_id, race_name, race_start_date, race_end_date )
VALUES ( 100, 'Giro d''Italia', '2015-05-09', '2015-05-31' );

INSERT INTO cycling.calendar ( race_id, race_name, race_start_date, race_end_date )
VALUES ( 101, 'Criterium du Dauphine', '2015-06-07', '2015-06-14' );

INSERT INTO cycling.calendar ( race_id, race_name, race_start_date, race_end_date )
VALUES ( 102, 'Tour de Suisse', '2015-06-13', '2015-06-21' );

INSERT INTO cycling.calendar ( race_id, race_name, race_start_date, race_end_date )
VALUES ( 103, 'Tour de France', '2015-07-04', '2015-07-26' );




select * from cycling.calendar;

// NEW FOR C*3.6
// Clustering columns can be used in a WHERE clause with ALLOW FILTERING without secondary indexes
// This query uses the clustering column "race_start_date" without an index and without using the partition key
// but using ALLOW FILTERING

/********************************* Q7:****************************************************/

// Find all calendar events for a particular year and month
CREATE TABLE IF NOT EXISTS cycling.upcoming_calendar (
	year int,
	month int,
	events list<text>,
	PRIMARY KEY (year, month)
);

INSERT INTO cycling.upcoming_calendar ( year, month, events )
VALUES ( 2015, 06, [ 'Criterium du Dauphine', 'Tour de Suisse' ] );

INSERT INTO cycling.upcoming_calendar ( year, month, events )
VALUES ( 2015, 07, [ 'Tour de France' ] );

select * from cycling.upcoming_calendar;

/

// Q9:
// Find all races for a particular cyclist

// CREATE TYPE - User-Defined Type, race
// CREATE TABLE WITH LIST, SIMPLE PRIMARY KEY
CREATE TYPE IF NOT EXISTS cycling.race (
	race_title text,
	race_date timestamp,
	race_time text
);

CREATE TABLE IF NOT EXISTS cycling.cyclist_races (
	id UUID PRIMARY KEY,
	lastname text,
	firstname text,
	races list<FROZEN<race>>);

INSERT INTO cycling.cyclist_races ( id, lastname, firstname, races )
VALUES ( 5b6962dd-3f90-4c93-8f61-eabfa4a803e2, 'VOS', 'Marianne', [ {
	race_title : 'Rabobank 7-Dorpenomloop Aalburg',
	race_date : '2015-05-09',
	race_time : '02:58:33'
}, {
	race_title : 'Ronde van Gelderland',
	race_date : '2015-04-19',
	race_time : '03:22:23'
} ] );

INSERT INTO cycling.cyclist_races ( id, lastname, firstname, races )
VALUES ( e7cd5752-bc0d-4157-a80f-7523add8dbcd, 'VAN DER BREGGEN', 'Anna', [ {
	race_title : 'Festival Luxembourgeois du cyclisme feminin Elsy Jacobs - Prologue - Garnich > Garnich',
	race_date : '2015-05-01',
	race_time : '08:13:00'
}, {
	race_title : 'Fest
ival Luxembourgeois du cyclisme feminin Elsy Jacobs - Stage 2 - Garnich > Garnich',
	race_date : '2015-05-02',
	race_time : '02:41:52'
}, {
	race_title : 'Festival Luxembourgeois du cyclisme feminin Elsy Jacobs - Stage 3 - Mamer > Mamer',
	race_date : '2015-05-03',
	race_time : '02:31:24'
} ] );

select * from cycling.cyclist_races;

// Q10:
// Find all teams for a particular cyclist associated with the year of membership
// teams map<int, text> is map<year, team_name>
// CREATE TABLE WITH MAP, SIMPLE PRIMARY KEY
CREATE TABLE IF NOT EXISTS cycling.cyclist_teams (
	id UUID PRIMARY KEY,
	lastname text,
	firstname text,
	teams map<int, text>);

INSERT INTO cycling.cyclist_teams ( id, lastname, firstname, teams )
VALUES ( 5b6962dd-3f90-4c93-8f61-eabfa4a803e2, 'VOS', 'Marianne', {
	2015 : 'Rabobank-Liv Woman Cycling Team',
	2014 : 'Rabobank-Liv Woman Cycling Team',
	2013 : 'Rabobank-Liv Giant',
	2012 : 'Rabobank Women Team',
	2011 : 'Nederland bloeit'
} );

INSERT INTO cycling.cyclist_teams ( id, lastname, firstname, teams )
VALUES ( e7cd5752-bc0d-4157-a80f-7523add8dbcd, 'VAN DER BREGGEN', 'Anna', {
	2015 : 'Rabobank-Liv Woman Cycling Team',
	2014 : 'Rabobank-Liv Woman Cycling Team',
	2013 : 'Sengers Ladies Cycling Team',
	2012 : 'Sengers Ladies Cycling Team',
	2009 : 'Team Flexpoint'
} );

INSERT INTO cycling.cyclist_teams ( id, lastname, firstname, teams )
VALUES ( cb07baad-eac8-4f65-b28a-bddc06a0de23, 'ARMITSTEAD', 'Elizabeth', {
	2015 : 'Boels-Dolmans Cycling Team',
	2014 : 'Boels-Dolmans Cycling Team',
	2013 : 'Boels-Dolmans Cycling Team',
	2012 : 'AA Drink - Leontien.nl',
	2011 : 'Team Garmin - Cervelo'
} );

select * from cycling.cyclist_teams;

// Q11:
// Find all stats for a particular cyclist
// CREATE TYPE -  UDT, basic_info
// CREATE TABLE with UDT, SIMPLE PRIMARY KEY
CREATE TYPE IF NOT EXISTS cycling.basic_info (
	birthday timestamp,
	nationality text,
	weight text,
	height text
);

CREATE TABLE IF NOT EXISTS cycling.cyclist_stats (
	id UUID,
	lastname text,
	basics FROZEN<basic_info>,
	PRIMARY KEY (id)
);

INSERT INTO cycling.cyclist_stats ( id, lastname, basics )
VALUES ( e7ae5cf3-d358-4d99-b900-85902fda9bb0, 'FRAME', {
	birthday : '1993-06-18',
	nationality : 'New Zealand',
	weight : null,
	height : null
} );

INSERT INTO cycling.cyclist_stats ( id, lastname, basics )
VALUES ( 6cbc55e9-1943-47dc-91f2-f8f9e95992eb, 'VIGANO', {
	birthday : '1984-06-12',
	nationality : 'Italy',
	weight : '67 kg',
	height : '1.82 m'
} );

INSERT INTO cycling.cyclist_stats ( id, lastname, basics )
VALUES ( 220844bf-4860-49d6-9a4b-6b5d3a79cbfb, 'TIRALONGO', {
	birthday : '1977-07-08',
	nationality : 'Italy',
	weight : '63 kg',
	height : '1.78 m'
} );

select * from cycling.cyclist_stats;
