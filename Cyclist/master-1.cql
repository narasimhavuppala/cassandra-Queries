
// NEW IN C* 3.6
// UPDATE AND DELETE single fields in UDTs with only non-collection fields
// CHANGE "CREATE TABLE IN LAST EXAMPLE TO non-frozen
CREATE TABLE cycling.cyclist_stats ( id UUID, lastname text, basics basic_info, PRIMARY KEY (id) );
// Now birthday can be updated separate from nationality, weight, and height
UPDATE cyclist_stats SET basics.birthday = '2000-12-12' WHERE id = 220844bf-4860-49d6-9a4b-6b5d3a79cbfb;

// Q12:
// Find total number of PCS points for a particular cyclist
// CREATE TABLE WITH PRIMARY KEY: PARTITION KEY + 1 CLUSTERING COLUMN
// USE STANDARD AGGREGATE IN QUERY
CREATE TABLE cycling.cyclist_points (id UUID, firstname text, lastname text, race_title text, race_points int, PRIMARY KEY (id, race_points ));
INSERT INTO cycling.cyclist_points (id, firstname, lastname, race_title, race_points) VALUES (e3b19ec4-774a-4d1c-9e5a-decec1e30aac, 'Giorgia','BRONZINI', 'Tour of Chongming Island World Cup', 120);
INSERT INTO cycling.cyclist_points (id, firstname, lastname, race_title, race_points) VALUES (e3b19ec4-774a-4d1c-9e5a-decec1e30aac, 'Giorgia','BRONZINI', 'Trofeo Alfredo Binda - Comune di Cittiglio', 6);
INSERT INTO cycling.cyclist_points (id, firstname, lastname, race_title, race_points) VALUES (e3b19ec4-774a-4d1c-9e5a-decec1e30aac, 'Giorgia','BRONZINI', 'Acht van Westerveld', 75);
INSERT INTO cycling.cyclist_points (id, firstname, lastname, race_title, race_points) VALUES (220844bf-4860-49d6-9a4b-6b5d3a79cbfb, 'Paolo','TIRALONGO', '98th Giro d''Italia - Stage 15', 2);

// Q13:
// USES TABLE cycling.cyclist_points
// Find total number of PCS points for a particular cyclist using a user-defined function (UDF) created using java function log
// cassandra.yaml must be modified to allow UDFs to work
// enable_user_defined_functions: true (false by default)
// CREATE UDF
CREATE TABLE cycling.cyclist_points (id UUID, firstname text, lastname text, race_title text, race_points double, PRIMARY KEY (id, race_points ));
INSERT INTO cycling.cyclist_points (id, firstname, lastname, race_title, race_points) VALUES (e3b19ec4-774a-4d1c-9e5a-decec1e30aac, 'Giorgia','BRONZINI', 'Tour of Chongming Island World Cup', 120);
INSERT INTO cycling.cyclist_points (id, firstname, lastname, race_title, race_points) VALUES (e3b19ec4-774a-4d1c-9e5a-decec1e30aac, 'Giorgia','BRONZINI', 'Trofeo Alfredo Binda - Comune di Cittiglio', 6);
INSERT INTO cycling.cyclist_points (id, firstname, lastname, race_title, race_points) VALUES (e3b19ec4-774a-4d1c-9e5a-decec1e30aac, 'Giorgia','BRONZINI', 'Acht van Westerveld', 75);
INSERT INTO cycling.cyclist_points (id, firstname, lastname, race_title, race_points) VALUES (220844bf-4860-49d6-9a4b-6b5d3a79cbfb, 'Paolo','TIRALONGO', '98th Giro d''Italia - Stage 15', 2);
CREATE OR REPLACE FUNCTION cycling.fLog (input double) CALLED ON NULL INPUT RETURNS double LANGUAGE java AS 'return Double.valueOf(Math.log(input.doubleValue()));';

// Q14:
//Find the average race_time in seconds for a particular race for a particular team.
// CREATE UDA that computes the average value
//CREATE TABLE WITH SIMPLE PRIMARY KEY: PARTITION KEY + 2 CLUSTERING COLUMNS
CREATE OR REPLACE FUNCTION cycling.avgState ( state tuple<int,bigint>, val int ) CALLED ON NULL INPUT RETURNS tuple<int,bigint> LANGUAGE java AS 'if (val !=null) { state.setInt(0, state.getInt(0)+1); state.setLong(1, state.getLong(1)+val.intValue()); } return state;';
CREATE OR REPLACE FUNCTION cycling.avgFinal ( state tuple<int,bigint> ) CALLED ON NULL INPUT RETURNS double LANGUAGE java AS 'double r = 0; if (state.getInt(0) == 0) return null; r = state.getLong(1); r/= state.getInt(0); return Double.valueOf(r);';
CREATE AGGREGATE cycling.average ( int ) SFUNC avgState STYPE tuple<int,bigint> FINALFUNC avgFinal INITCOND (0,0);
CREATE TABLE cycling.team_average (team_name text, cyclist_name text, cyclist_time_sec int, race_title text, PRIMARY KEY (team_name, race_title,cyclist_name));
INSERT INTO cycling.team_average (team_name, cyclist_name, cyclist_time_sec, race_title) VALUES ('UnitedHealthCare Pro Cycling Womens Team','Katie HALL',11449,'Amgen Tour of California Women''s Race presented by SRAM - Stage 1 - Lake Tahoe > Lake Tahoe');
INSERT INTO cycling.team_average (team_name, cyclist_name, cyclist_time_sec, race_title) VALUES ('UnitedHealthCare Pro Cycling Womens Team','Linda VILLUMSEN',11485,'Amgen Tour of California Women''s Race presented by SRAM - Stage 1 - Lake Tahoe > Lake Tahoe');
INSERT INTO cycling.team_average (team_name, cyclist_name, cyclist_time_sec, race_title) VALUES ('UnitedHealthCare Pro Cycling Womens Team','Hannah BARNES',11490,'Amgen Tour of California Women''s Race presented by SRAM - Stage 1 - Lake Tahoe > Lake Tahoe');
INSERT INTO cycling.team_average (team_name, cyclist_name, cyclist_time_sec, race_title) VALUES ('Velocio-SRAM','Alena AMIALIUSIK',11451,'Amgen Tour of California Women''s Race presented by SRAM - Stage 1 - Lake Tahoe > Lake Tahoe');
INSERT INTO cycling.team_average (team_name, cyclist_name, cyclist_time_sec, race_title) VALUES ('Velocio-SRAM','Trixi WORRACK',11453,'Amgen Tour of California Women''s Race presented by SRAM - Stage 1 - Lake Tahoe > Lake Tahoe');
INSERT INTO cycling.team_average (team_name, cyclist_name, cyclist_time_sec, race_title) VALUES ('TWENTY16 presented by Sho-Air','Lauren KOMANSKI',11451,'Amgen Tour of California Women''s Race presented by SRAM - Stage 1 - Lake Tahoe > Lake Tahoe');

// Q15:
// CREATE INDEX - PARTITION KEY
// Uses cycling.rank_by_year_and_name
// Find rank for all races for a particular race year
CREATE INDEX ryear ON cycling.rank_by_year_and_name (race_year);
// This will not work without the index, because the table has a composite partition key
SELECT * FROM cycling.rank_by_year_and_name WHERE race_year=2015;
// INDEX on clustering column
CREATE INDEX rrank ON cycling.rank_by_year_and_name (rank);

// Q16:
// CREATE INDEX - COLLECTION - SET
// Find all the cyclists that have been on a particular team
CREATE INDEX team ON cycling.cyclist_career_teams (teams);

// Q17:
// CREATE INDEX - COLLECTION ON MAP KEYS
// Find all cyclist/team combinations for a particular year
// CREATE TABLE cycling.cyclist_teams ( id UUID PRIMARY KEY, lastname text, firstname text, teams map<int,text> );
CREATE INDEX team_year ON cycling.cyclist_teams (KEYS(teams));

// Q35:
// CREATE INDEX - ENTRIES ON MAP KEYS
// ONLY VALID FOR MAP TYPE
CREATE TABLE cycling.birthday_list (cyclist_name text PRIMARY KEY, blist map<text,text>);
INSERT INTO cycling.birthday_list (cyclist_name, blist) VALUES ('Allan DAVIS', {'age':'35', 'bday':'27/07/1980', 'nation':'AUSTRALIA'});
INSERT INTO cycling.birthday_list (cyclist_name, blist) VALUES ('Claudio VANDELLI', {'age':'54', 'bday':'27/07/1961', 'nation':'ITALY'});
INSERT INTO cycling.birthday_list (cyclist_name, blist) VALUES ('Laurence BOURQUE', {'age':'23', 'bday':'27/07/1992', 'nation':'CANADA'});
INSERT INTO cycling.birthday_list (cyclist_name, blist) VALUES ('Claudio HEINEN', {'age':'23', 'bday':'27/07/1992', 'nation':'GERMANY'});
INSERT INTO cycling.birthday_list (cyclist_name, blist) VALUES ('Luc HAGENAARS', {'age':'28', 'bday':'27/07/1987', 'nation':'NETHERLANDS'});
INSERT INTO cycling.birthday_list (cyclist_name, blist) VALUES ('Toine POELS', {'age':'52', 'bday':'27/07/1963', 'nation':'NETHERLANDS'});
CREATE INDEX blist_idx ON cycling.birthday_list (ENTRIES(blist));

// Q36:
// CREATE INDEX - FULL ON FROZEN COLLECTION
// ONLY VALID FOR FROZEN COLLECTIONS (SET, LIST, MAP)
CREATE TABLE cycling.race_starts (cyclist_name text PRIMARY KEY, rnumbers FROZEN<LIST<int>>);
CREATE INDEX rnumbers_idx ON cycling.race_starts (FULL(rnumbers));
INSERT INTO cycling.race_starts (cyclist_name,rnumbers) VALUES ('Alexander KRISTOFF',[40,5,14]);
INSERT INTO cycling.race_starts (cyclist_name,rnumbers) VALUES ('Alejandro VALVERDE',[67,17,20]);
INSERT INTO cycling.race_starts (cyclist_name,rnumbers) VALUES ('Alberto CONTADOR',[61,14,7]);
INSERT INTO cycling.race_starts (cyclist_name,rnumbers) VALUES ('Christopher FROOME',[28,10,6]);
INSERT INTO cycling.race_starts (cyclist_name,rnumbers) VALUES ('John DEGENKOLB',[39,7,14]);

// NOT A QUERY, JUST AN EXAMPLE
// INSERT DATA IN JSON FORMAT
INSERT INTO cycling.cyclist_category JSON '{ "category" : "GC", "points" : 780, "id" : "829aa84a-4bba-411f-a4fb-38167a987cda", "lastname" : "SUTHERLAND" }';
// null INSERTION EXAMPLE
INSERT INTO cycling.cyclist_category JSON '{ "category" : "Sprint", "points" : 700, "id" : "829aa84a-4bba-411f-a4fb-38167a987cda" }';

// NOT A QUERY, JUST AN EXAMPLE
// UPDATE SET
// Can only be +
// Add team to a cyclist's list of teams, order doesn't matter; this example adds it to the end
UPDATE cycling.cyclist_career_teams SET teams = teams + {'Team DSB - Ballast Nedam'} WHERE id=5b6962dd-3f90-4c93-8f61-eabfa4a803e2;

// NOT A QUERY, JUST AN EXAMPLE
// UPDATE LIST
// Add events to the events list with either +/- or a specific place in the list like events[2]
UPDATE cycling.upcoming_calendar SET events = ['The Parx Casino Philly Cycling Classic'] + events WHERE year = 2015 AND month = 06;
UPDATE cycling.upcoming_calendar SET events[2] = 'Vuelta Ciclista a Venezuela' WHERE year = 2015 AND month = 06;

// NOT A QUERY, JUST AN EXAMPLE
// UPDATE MAP
// Can only be +
UPDATE cycling.cyclist_teams SET teams = teams + {2009 : 'DSB Bank - Nederland bloeit'} WHERE id = 5b6962dd-3f90-4c93-8f61-eabfa4a803e2;
UPDATE cycling.cyclist_teams SET teams[2006] = 'Team DSB - Ballast Nedam' WHERE id = 5b6962dd-3f90-4c93-8f61-eabfa4a803e2;

// Q22:
// UPDATE AND SELECT USING TTL
// QUERY TO FIND TIME-TO-LIVE
// Insert is to put in dummy record, UPDATE gives it a TTL
// Repeated use of the SELECT will show the TTL as it counts down
INSERT INTO cycling.calendar (race_id, race_name, race_start_date, race_end_date) VALUES (200, 'placeholder', '2015-05-27', '2015-05-27') USING TTL;
UPDATE cycling.calendar USING TTL 300 SET race_name = 'dummy' WHERE race_id = 200 AND race_start_date = '2015-05-27' AND race_end_date = '2015-05-27';

// Q18:
// QUERY WITH ORDER BY
// Find all calendar events for a particular year and order by month

// Q19:
// QUERY WITH INEQUALITIES
// Find all calendar events for a particular year between two set months

// NOT A QUERY, REALLY, JUST AN EXAMPLE
// SELECT and GET RESULTS in JSON FORMAT

// Q20:
// QUERY - WHERE ... IN SIMPLE
// Notice the difference between using 'ORDER BY points DESC' and not using it - changes the order of reporting
// Find all cyclists for a particular category and order by points

// Q21:
// QUERY - WHERE ... IN COMPLEX
// Find particular races in a range of start and end dates

// Q23 and 24:
// Standard Aggregates
// Find sum of cyclist points for a particular cyclist
// Find the number of cyclists from a particular country

// Q25
// QUERY - SCAN A PARTITION
// Find all cyclists that finished a race in a particular window of time
CREATE TABLE cycling.race_times (race_name text, cyclist_name text, race_time text, PRIMARY KEY (race_name, race_time));
INSERT INTO cycling.race_times (race_name, cyclist_name, race_time) VALUES ('17th Santos Tour Down Under', 'Rohan DENNIS', '19:15:18');
INSERT INTO cycling.race_times (race_name, cyclist_name, race_time) VALUES ('17th Santos Tour Down Under', 'Richie PORTE', '19:15:20');
INSERT INTO cycling.race_times (race_name, cyclist_name, race_time) VALUES ('17th Santos Tour Down Under', 'Cadel EVANS', '19:15:38');
INSERT INTO cycling.race_times (race_name, cyclist_name, race_time) VALUES ('17th Santos Tour Down Under', 'Tom DUMOULIN', '19:15:40');

// NOT A QUERY, JUST AN EXAMPLE:
// BATCH statement
// Insert data into multiple tables using a BATCH statement
// Note that what is inserted is data for the SAME cyclist, to two tables
BEGIN BATCH
  INSERT INTO cycling.cyclist_name (id, lastname, firstname) VALUES (c7fceba0-c141-4207-9494-a29f9809de6f, 'PIETERS', 'Amy');
  INSERT INTO cycling.cyclist_id (lastname, firstname, age, id) VALUES ('PIETERS', 'Amy', 23, c7fceba0-c141-4207-9494-a29f9809de6f);
APPLY BATCH;

// NOT A QUERY, JUST AN EXAMPLE:
// BATCH statement MISUSE
// Insert data into same table, but involves multiple nodes due to partition key = id
BEGIN BATCH
INSERT INTO cycling.cyclist_name (id, lastname, firstname) VALUES  (6d5f1663-89c0-45fc-8cfd-60a373b01622,'HOSKINS', 'Melissa');
INSERT INTO cycling.cyclist_name (id, lastname, firstname) VALUES  (38ab64b6-26cc-4de9-ab28-c257cf011659,'FERNANDES', 'Marcia');
INSERT INTO cycling.cyclist_name (id, lastname, firstname) VALUES  (9011d3be-d35c-4a8d-83f7-a3c543789ee7,'NIEWIADOMA', 'Katarzyna');
INSERT INTO cycling.cyclist_name (id, lastname, firstname) VALUES  (95addc4c-459e-4ed7-b4b5-472f19a67995,'ADRIAN', 'Vera');
APPLY BATCH;

// NOT A QUERY, JUST AN EXAMPLE:
// BATCH statement WITH CONDITIONAL "IF NOT EXISTS"
// EXAMPLE USES CYCLIST'S EXPENSES
CREATE TABLE cycling.cyclist_expenses ( cyclist_name text, balance float STATIC, expense_id int, amount float, description text, paid boolean, PRIMARY KEY (cyclist_name, expense_id) );
BEGIN BATCH
INSERT INTO cycling.cyclist_expenses (cyclist_name, balance) VALUES ('Vera ADRIAN', 0) IF NOT EXISTS;
INSERT INTO cycling.cyclist_expenses (cyclist_name, expense_id, amount, description, paid) VALUES ('Vera ADRIAN', 1, 7.95, 'Breakfast', false);
APPLY BATCH;

UPDATE cycling.cyclist_expenses SET balance = -7.95 WHERE cyclist_name = 'Vera ADRIAN' IF balance = 0;

// NOT A QUERY, JUST AN EXAMPLE:
// BATCH statement WITH CONDITIONAL "IF"
BEGIN BATCH
INSERT INTO cycling.cyclist_expenses (cyclist_name, expense_id, amount, description, paid) VALUES ('Vera ADRIAN', 2, 13.44, 'Lunch', true);
INSERT INTO cycling.cyclist_expenses (cyclist_name, expense_id, amount, description, paid) VALUES ('Vera ADRIAN', 3, 25.00, 'Dinner', false);
UPDATE cycling.cyclist_expenses SET balance = -32.95 WHERE cyclist_name = 'Vera ADRIAN' IF balance = -7.95;
APPLY BATCH;

//using a different timestamp for each request
BEGIN BATCH
INSERT INTO cycling.cyclist_expenses (cyclist_name, expense_id, amount, description, paid) VALUES ('Vera ADRIAN', 2, 13.44, 'Lunch', true) USING TIMESTAMP 1481124356754405;
INSERT INTO cycling.cyclist_expenses (cyclist_name, expense_id, amount, description, paid) VALUES ('Vera ADRIAN', 3, 25.00, 'Dinner', false)  USING TIMESTAMP 1479922052163972;
APPLY BATCH;

//using a client provided the same timestamp for all requests
BEGIN BATCH USING TIMESTAMP 1481124356754405
INSERT INTO cycling.cyclist_expenses (cyclist_name, expense_id, amount, description, paid) VALUES ('Vera ADRIAN', 2, 13.44, 'Lunch', true);
INSERT INTO cycling.cyclist_expenses (cyclist_name, expense_id, amount, description, paid) VALUES ('Vera ADRIAN', 3, 25.00, 'Dinner', false);
APPLY BATCH;

//using the cassandra provided the same timestamp for all requests
BEGIN BATCH USING TIMESTAMP
INSERT INTO cycling.cyclist_expenses (cyclist_name, expense_id, amount, description, paid) VALUES ('Vera ADRIAN', 2, 13.44, 'Lunch', true);
INSERT INTO cycling.cyclist_expenses (cyclist_name, expense_id, amount, description, paid) VALUES ('Vera ADRIAN', 3, 25.00, 'Dinner', false);
APPLY BATCH;

//query to show the time the records were written

// LWT in batches with timestamps fail
BEGIN BATCH USING TIMESTAMP 1481124356754405
INSERT INTO cycling.cyclist_expenses (cyclist_name, expense_id, amount, description, paid) VALUES ('Vera ADRIAN', 2, 13.44, 'Lunch', true);
INSERT INTO cycling.cyclist_expenses (cyclist_name, expense_id, amount, description, paid) VALUES ('Vera ADRIAN', 3, 25.00, 'Dinner', false) IF NOT EXISTS;
APPLY BATCH;

// NOT A QUERY, JUST AN EXAMPLE:
// BATCH statement WITH CONDITIONAL "IF"
BEGIN BATCH
UPDATE cycling.cyclist_expenses SET balance = 0 WHERE cyclist_name = 'Vera ADRIAN' IF balance = -32.95;
UPDATE cycling.cyclist_expenses SET paid = true WHERE cyclist_name = 'Vera ADRIAN' AND expense_id = 1 IF paid = false;
UPDATE cycling.cyclist_expenses SET paid = true WHERE cyclist_name = 'Vera ADRIAN' AND expense_id = 3 IF paid = false;
APPLY BATCH;

// NOT A QUERY, JUST AN EXAMPLE
// LIGHTWEIGHT TRANSACTION
// Insert or update information using a conditional statement
INSERT INTO cycling.cyclist_name (id, lastname, firstname) VALUES (c4b65263-fe58-4846-83e8-f0e1c13d518f, 'RATTO', 'Rissella') IF NOT EXISTS;

// UPDATE USING LIGHTWEIGHT TRANSACTION
UPDATE cycling.cyclist_name SET firstname = 'Rossella' WHERE id=c4b65263-fe58-4846-83e8-f0e1c13d518f IF lastname = 'RATTO';

// Q26
// QUERY USING MULTIPLE INDEXES
// DISCUSSION OF THE NEED FOR ALLOW FILTERING
// IS THIS BETTER THAN cyclist_stats??
CREATE TABLE cycling.cyclist_alt_stats ( id UUID PRIMARY KEY, lastname text, birthday timestamp, nationality text, weight text, height text );
INSERT INTO cycling.cyclist_alt_stats (id, lastname, birthday, nationality, weight, height) VALUES (ed584e99-80f7-4b13-9a90-9dc5571e6821,'TSATEVICH', '1989-07-05', 'Russia', '64 kg', '1.69 m');
INSERT INTO cycling.cyclist_alt_stats (id, lastname, birthday, nationality, weight, height) VALUES (a9e96714-2dd0-41f9-8bd0-557196a44ecf,'ISAYCHEV', '1986-04-21', 'Russia', '80 kg', '1.88 m');
INSERT INTO cycling.cyclist_alt_stats (id, lastname, birthday, nationality, weight, height) VALUES (823ec386-2a46-45c9-be41-2425a4b7658e,'BELKOV', '1985-01-09', 'Russia', '71 kg', '1.84 m');
INSERT INTO cycling.cyclist_alt_stats (id, lastname, birthday, nationality, weight, height) VALUES (e0953617-07eb-4c82-8f91-3b2757981625,'BRUTT', '1982-01-29', 'Russia', '68 kg', '1.78 m');
INSERT INTO cycling.cyclist_alt_stats (id, lastname, birthday, nationality, weight, height) VALUES (078654a6-42fa-4142-ae43-cebdc67bd902,'LAGUTIN', '1981-01-14', 'Russia', '63 kg', '1.82 m');
INSERT INTO cycling.cyclist_alt_stats (id, lastname, birthday, nationality, weight, height) VALUES (d74d6e70-7484-4df5-8551-f5090c37f617,'GRMAY', '1991-08-25', 'Ethiopia', '63 kg', '1.75 m');
INSERT INTO cycling.cyclist_alt_stats (id, lastname, birthday, nationality, weight, height) VALUES (c09e9451-50da-483d-8108-e6bea2e827b3,'VEIKKANEN', '1981-03-29', 'Finland', '66 kg', '1.78 m');
INSERT INTO cycling.cyclist_alt_stats (id, lastname, birthday, nationality, weight, height) VALUES (f1deff54-7d96-4981-b14a-b70be4da82d2,'TLEUBAYEV', '1987-03-07', 'Kazakhstan', null, null);
INSERT INTO cycling.cyclist_alt_stats (id, lastname, birthday, nationality, weight, height) VALUES (1ba0417d-62da-4103-b710-de6fb227db6f,'PAULINHO', '1990-05-27', 'Portugal', null, null);
INSERT INTO cycling.cyclist_alt_stats (id, lastname, birthday, nationality, weight, height) VALUES (4ceb495c-55ab-4f71-83b9-81117252bb13,'DUVAL', '1990-05-27','France', null, null);
CREATE INDEX birthday_idx ON cycling.cyclist_alt_stats (birthday);
CREATE INDEX nationality_idx ON cycling.cyclist_alt_stats (nationality);

// Q27
// USING EXPIRING DATA AND TTL TO DISPLAY THE LAST 3 DAYS race data
// 3 days in seconds is 259,200
// 2 days in seconds is 172800
// Data will vanish when its TTL runs out
CREATE TABLE cycling.last_3_days (race_name text, year timestamp, rank int, cyclist_name text, PRIMARY KEY (year, rank, cyclist_name));
INSERT INTO cycling.last_3_days (race_name, year, rank, cyclist_name) VALUES ('Giro d''Italia Stage 16','2015-05-26',1,'Mikel Landa') USING TTL 259200;
INSERT INTO cycling.last_3_days (race_name, year, rank, cyclist_name) VALUES ('Giro d''Italia Stage 16','2015-05-26',2,'Steven Kruijswijk') USING TTL 259200;
INSERT INTO cycling.last_3_days (race_name, year, rank, cyclist_name) VALUES ('Giro d''Italia Stage 16','2015-05-26',3,'Alberto Contador') USING TTL 259200;
INSERT INTO cycling.last_3_days (race_name, year, rank, cyclist_name) VALUES ('National Championships United States - Road Race (NC)','2015-05-25',1,'Matthew Busche') USING TTL 172800;
INSERT INTO cycling.last_3_days (race_name, year, rank, cyclist_name) VALUES ('National Championships United States - Road Race (NC)','2015-05-25',2,'Joe Dombrowski') USING TTL 172800;
INSERT INTO cycling.last_3_days (race_name, year, rank, cyclist_name) VALUES ('National Championships United States - Road Race (NC)','2015-05-25',3,'Kiel Reijnen') USING TTL 172800;

// Q28:
// QUERY USING FUNCTION TOKEN()
// Note how results are not consistent with dates alone; partitioner order is how they are returned
// All 6 entries show
// SELECT * FROM cycling.last_3_days WHERE token(year) > token ('2015-05-24');
// No entries show
// SELECT * FROM cycling.last_3_days WHERE token(year) > token ('2015-05-25');
// 3 entries for 2015-05-25 show
// SELECT * FROM cycling.last_3_days WHERE token(year) > token ('2015-05-26');
// No entries show
// SELECT * FROM cycling.last_3_days WHERE token(year) > token ('2015-05-27');
// SELECT token(year) FROM cycling.last_3_days; //PRINTS partition hash
// MIXED TOKEN AND PARTITION KEY
// SELECT * FROM cycling.last_3_days WHERE token(year) < token ('2015-05-26') AND year IN ('2015-05-24','2015-05-25');


// DELETE WHOLE ROW
// Leave column(s) blank
// DELETE FROM cycling.calendar WHERE race_id = 200;

// DELETE COLUMN VALUE
// DELETE lastname FROM cycling.cyclist_name WHERE id = c7fceba0-c141-4207-9494-a29f9809de6f;
// UPDATE cycling.cyclist_name SET lastname = 'PIETERS' WHERE id = c7fceba0-c141-4207-9494-a29f9809de6f; // TO RESTORE THE COLUMN VALUE

// DELETE ITEM FROM LIST
// DELETE events[2] FROM cycling.upcoming_calendar WHERE year = 2015 AND month = 06;

// DELETE ITEM FROM MAP
// DELETE teams[2009] FROM cycling.cyclist_teams WHERE id=e7cd5752-bc0d-4157-a80f-7523add8dbcd;
// UPDATE cycling.cyclist_teams SET teams = teams + {2009 : 'Team Flexpoint' } WHERE id = e7cd5752-bc0d-4157-a80f-7523add8dbcd; // TO RESTORE THE MAP VALUE

// ALTER TABLE
// ADD COLUMN
ALTER TABLE cycling.cyclist_alt_stats ADD age int;

// ALTER TABLE WITH COLLECTION
ALTER TABLE cycling.upcoming_calendar ADD description map<text,text>;
UPDATE cycling.upcoming_calendar SET description = description + {'Criterium du Dauphine' : 'Easy race', 'Tour du Suisse' : 'Hard uphill race'} WHERE year = 2015 AND month = 6;

// ALTER TABLE AND ALTER COLUMN TYPE
// ADDS COLUMN as varchar and then changes it to text
ALTER TABLE cycling.cyclist_alt_stats ADD favorite_color varchar;
ALTER TABLE cycling.cyclist_alt_stats ALTER favorite_color TYPE text;


// ALTER TYPE
ALTER TYPE cycling.fullname ADD middlename text;
ALTER TYPE cycling.fullname RENAME middlename TO middleinitial;

// TUPLE WAS USED IN THE UDA TO HOLD 2 values - see example in UDA section

// Q29:
// TUPLE
// Store the latitude/longitude waypoints for the route of a race
CREATE TABLE cycling.route (race_id int, race_name text, point_id int, lat_long tuple<text, tuple<float,float>>, PRIMARY KEY (race_id, point_id));
INSERT INTO cycling.route (race_id, race_name, point_id, lat_long) VALUES (500, '47th Tour du Pays de Vaud', 1, ('Onnens', (46.8444,6.6667)));
INSERT INTO cycling.route (race_id, race_name, point_id, lat_long) VALUES (500, '47th Tour du Pays de Vaud', 2, ('Champagne', (46.833, 6.65)));
INSERT INTO cycling.route (race_id, race_name, point_id, lat_long) VALUES (500, '47th Tour du Pays de Vaud', 3, ('Novalle', (46.833, 6.6)));
INSERT INTO cycling.route (race_id, race_name, point_id, lat_long) VALUES (500, '47th Tour du Pays de Vaud', 4, ('Vuiteboeuf', (46.8, 6.55)));
INSERT INTO cycling.route (race_id, race_name, point_id, lat_long) VALUES (500, '47th Tour du Pays de Vaud', 5, ('Baulmes', (46.7833, 6.5333)));
INSERT INTO cycling.route (race_id, race_name, point_id, lat_long) VALUES (500, '47th Tour du Pays de Vaud', 6, ('Les Clées', (46.7222, 6.5222)));
// SELECT race_name, point_id, lat_long AS City_Latitude_Longitude FROM cycling.route; // Showcases 'AS' to rename column header

// Q30:
// QUERY USING DISTINCT
// Find all the distinct race_id values from cycling.route
// SELECT DISTINCT race_id from cycling.route;

// Q31:
// TUPLE
// Rank nations by points, including top cyclist
// tuple is rank, name, points
CREATE TABLE cycling.nation_rank ( nation text PRIMARY KEY, info tuple<int,text,int> );
INSERT INTO cycling.nation_rank (nation, info) VALUES ('Spain', (1,'Alejandro VALVERDE' , 9054));
INSERT INTO cycling.nation_rank (nation, info) VALUES ('France', (2,'Sylvain CHAVANEL' , 6339));
INSERT INTO cycling.nation_rank (nation, info) VALUES ('Belgium', (3,'Phillippe GILBERT' , 6222));
INSERT INTO cycling.nation_rank (nation, info) VALUES ('Italy', (4,'Davide REBELLINI' , 6090));
// SELECT * FROM cycling.nation_rank;

// Q32:
// TUPLE
// Popular Riders
CREATE TABLE cycling.popular (rank int PRIMARY KEY, cinfo tuple<text,text,int> );
INSERT INTO cycling.popular (rank, cinfo) VALUES (1, ('Spain', 'Mikel LANDA', 1137));
INSERT INTO cycling.popular (rank, cinfo) VALUES (2, ('Netherlands', 'Steven KRUIJSWIJK', 621));
INSERT INTO cycling.popular (rank, cinfo) VALUES (3, ('USA', 'Matthew BUSCHE', 230));
INSERT INTO cycling.popular (rank, cinfo) VALUES (4, ('Italy', 'Fabio ARU', 163));
INSERT INTO cycling.popular (rank, cinfo) VALUES (5, ('Canada', 'Ryder HESJEDAL', 148));
// SELECT * FROM cycling.popular;

// Q33:
// COUNTER TABLE
// Keep the count for popularity, incrementing or decrementing
CREATE TABLE cycling.popular_count ( id UUID PRIMARY KEY, popularity counter );
UPDATE cycling.popular_count SET popularity = popularity + 1 WHERE id = 6ab09bec-e68e-48d9-a5f8-97e6fb4c9b47;
// SELECT * FROM cycling.popular_count;
UPDATE cycling.popular_count SET popularity = popularity + 125 WHERE id = 6ab09bec-e68e-48d9-a5f8-97e6fb4c9b47;
// SELECT * FROM cycling.popular_count;
UPDATE cycling.popular_count SET popularity = popularity - 64 WHERE id = 6ab09bec-e68e-48d9-a5f8-97e6fb4c9b47;
// SELECT * FROM cycling.popular_count;

// Q34:
// Find the writetime for a column in a table
// SELECT WRITETIME (firstname) FROM cycling.cyclist_points WHERE id=220844bf-4860-49d6-9a4b-6b5d3a79cbfb;

// NOT A QUERY
// INSERTING STRING CONSTANT USING DOUBLE DOLLAR SIGNS
INSERT INTO cycling.calendar (race_id, race_start_date, race_end_date, race_name) VALUES (201, '2015-02-18', '2015-02-22', $$Women's Tour of New Zealand$$);

// ROLES, USERS, PERMISSIONS
// cassandra.yaml must be changed to allow login with username and password
// authenticator: PasswordAuthenticator (AllowAllAuthenticator by default)
// authorizer: CassandraAuthorizer (AllowAllAuthorizer by default)
CREATE role IF NOT EXISTS sandy WITH PASSWORD = 'password' AND superuser = false and LOGIN = true;
CREATE role chuck WITH WITH PASSWORD = 'password' AND superuser = true and LOGIN = true
CREATE ROLE IF NOT EXISTS team_manager WITH PASSWORD = 'password';
CREATE ROLE sys_admin WITH PASSWORD = 'password' AND LOGIN = true AND SUPERUSER = true;
ALTER ROLE sys_admin WITH PASSWORD = 'password' AND SUPERUSER = false;
GRANT sys_admin TO team_manager;
GRANT team_manager TO sandy;

// REVOKE sys_admin FROM team_manager;
// REVOKE team_manager FROM sandy;
// DROP ROLE IF EXISTS sys_admin;
GRANT MODIFY ON KEYSPACE cycling TO team_manager;
GRANT DESCRIBE ON ALL ROLES TO sys_admin;
GRANT AUTHORIZE ALL KEYSPACES TO sys_admin;
// REVOKE SELECT ON ALL KEYSPACES FROM team_manager;
// REVOKE EXECUTE ON FUNCTION cycling.fLog(double) FROM team_manager;
// LIST ALL PERMISSIONS OF sandy;
// LIST ALL PERMISSIONS ON cycling.cyclist_name OF chuck;

// Q35:
// MATERIALIZED VIEW
CREATE TABLE cycling.cyclist_mv (cid UUID PRIMARY KEY, name text, age int, birthday date, country text);
INSERT INTO cycling.cyclist_mv (cid,name,age,birthday,country) VALUES (e7ae5cf3-d358-4d99-b900-85902fda9bb0,'Alex FRAME', 22, '1993-06-18', 'New Zealand');
INSERT INTO cycling.cyclist_mv (cid,name,age,birthday,country) VALUES (220844bf-4860-49d6-9a4b-6b5d3a79cbfb,'Paolo TIRALONGO', 38, '1977-07-08', 'Italy');
INSERT INTO cycling.cyclist_mv (cid,name,age,birthday,country) VALUES (6ab09bec-e68e-48d9-a5f8-97e6fb4c9b47,'Steven KRUIKSWIJK', 28, '1987-06-07', 'Netherlands');
INSERT INTO cycling.cyclist_mv (cid,name,age,birthday,country) VALUES (ffdfa2a7-5fc6-49a7-bfdc-3fcdcfdd7156,'Pascal EENKHOORN', 18, '1997-02-08', 'Netherlands');
INSERT INTO cycling.cyclist_mv (cid,name,age,birthday,country) VALUES (18f471bf-f631-4bc4-a9a2-d6f6cf5ea503,'Bram WELTEN', 18, '1997-03-29', 'Netherlands');
INSERT INTO cycling.cyclist_mv (cid,name,age,birthday,country) VALUES (15a116fc-b833-4da6-ab9a-4a7775752836,'Adrien COSTA', 18, '1997-08-19', 'United States');
INSERT INTO cycling.cyclist_mv (cid,name,age,birthday,country) VALUES (862cc51f-00a1-4d5a-976b-a359cab7300e,'Joakim BUKDAL', 20, '1994-09-04', 'Denmark');
INSERT INTO cycling.cyclist_mv (cid,name,age,birthday,country) VALUES (c9c9c484-5e4a-4542-8203-8d047a01b8a8,'Cristian EGIDIO', 27, '1987-09-04', 'Brazil');
INSERT INTO cycling.cyclist_mv (cid,name,age,birthday,country) VALUES (d1aad83b-be60-47a4-bd6e-069b8da0d97b,'Johannes HEIDER', 27, '1987-09-04','Germany');
CREATE MATERIALIZED VIEW cycling.cyclist_by_age AS SELECT age, birthday, name, country FROM cyclist_mv WHERE age is NOT NULL AND cid IS NOT NULL PRIMARY KEY (age, cid);
CREATE MATERIALIZED VIEW cycling.cyclist_by_country AS SELECT age, birthday, name, country FROM cyclist_mv WHERE country is NOT NULL AND cid IS NOT NULL PRIMARY KEY (country, cid);
CREATE MATERIALIZED VIEW cycling.cyclist_by_birthday AS SELECT age, birthday, name, country FROM cyclist_mv WHERE birthday is NOT NULL AND cid IS NOT NULL PRIMARY KEY (birthday, cid);
// SELECT age, name, birthday FROM cycling.cyclist_by_age WHERE age = 18;
// SELECT age, name, birthday FROM cycling.cyclist_by_country WHERE country = 'Netherlands';
// SELECT age, name, birthday FROM cycling.cyclist_by_birthday WHERE birthday = '1987-09-04';
// DROP MATERIALIZED VIEW cycling.cyclist_by_age;

// Q36:
// USING TIMESTAMP
INSERT INTO cycling.calendar (race_id, race_name, race_start_date, race_end_date) VALUES (200, 'placeholder', '2015-05-27', '2015-05-27') USING TIMESTAMP 123456789;

// SASI STUFF

// **********
// PREFIX - DEFAULT
// **********
// CASE SENSITIVE:
CREATE CUSTOM INDEX  fn_prefix ON cycling.cyclist_name (firstname) USING 'org.apache.cassandra.index.sasi.SASIIndex';

// THESE PRODUCE THE SAME RESULTS AS THE INDEX ABOVE
CREATE CUSTOM INDEX  fn_prefix_allcase ON cycling.cyclist_name (firstname) USING 'org.apache.cassandra.index.sasi.SASIIndex'
WITH OPTIONS = { 'case_sensitive': 'true' };
CREATE CUSTOM INDEX  fn_prefix_allcase ON cycling.cyclist_name (firstname) USING 'org.apache.cassandra.index.sasi.SASIIndex'
WITH OPTIONS = { 'case_sensitive': 'false' };

// CASE INSENSITIVE:
// (APPARENTLY, THE ANALYZER MUST BE ADDED TO CHANGE IT TO BE INSENSITIVE TO CASE)
CREATE CUSTOM INDEX fn_prefix_allcase ON cycling.cyclist_name (firstname) USING 'org.apache.cassandra.index.sasi.SASIIndex'
WITH OPTIONS = {
'analyzer_class': 'org.apache.cassandra.index.sasi.analyzer.NonTokenizingAnalyzer',
'case_sensitive': 'false'
 };

// *********
// CONTAINS - matches on SUFFIX instead of PREFIX only
// *********

// CASE SENSITIVE:
CREATE CUSTOM INDEX fn_contains ON cycling.cyclist_name (firstname) USING 'org.apache.cassandra.index.sasi.SASIIndex'
WITH OPTIONS = { 'mode': 'CONTAINS' };

// THIS PRODUCES THE SAME RESULTS AS THE INDEX ABOVE
CREATE CUSTOM INDEX fn_suffix_allcase ON cycling.cyclist_name (firstname) USING 'org.apache.cassandra.index.sasi.SASIIndex'
WITH OPTIONS = {
'mode': 'CONTAINS',
'case_sensitive': 'false'
};

// CASE INSENSITIVE:
CREATE CUSTOM INDEX fn_suffix_allcase ON cycling.cyclist_name (firstname) USING 'org.apache.cassandra.index.sasi.SASIIndex'
WITH OPTIONS = {
'mode': 'CONTAINS',
'analyzer_class': 'org.apache.cassandra.index.sasi.analyzer.NonTokenizingAnalyzer',
'case_sensitive': 'false'
};


// *** REVISION OF SPARSE BASED ON CASSANDRA-11383 TICKET ***
CREATE TABLE cycling.comments (commenter text, created_at timestamp, comment text, PRIMARY KEY (commenter));
INSERT INTO cycling.comments (commenter, comment, created_at) VALUES ('John', 'Fantastic race!', '2013-01-01 00:05:01.500');
INSERT INTO cycling.comments (commenter, comment, created_at) VALUES ('Jane', 'What a finish', '2013-01-01 00:05:01.400');
INSERT INTO cycling.comments (commenter, comment, created_at) VALUES ('Mary', 'Hated to see the race end.', '2013-01-01 00:05:01.300');
INSERT INTO cycling.comments (commenter, comment, created_at) VALUES ('Jonnie', 'Thankfully, it is over.', '2013-01-01 00:05:01.600');
CREATE CUSTOM INDEX fn_sparse ON cycling.comments (created_at) USING 'org.apache.cassandra.index.sasi.SASIIndex' WITH OPTIONS = { 'mode': 'SPARSE' };

// **********
// ANALYZERS
// **********
ALTER TABLE cycling.cyclist_name ADD comments text;
UPDATE cycling.cyclist_name SET comments ='Rides hard, gets along with others, a real winner' WHERE id = fb372533-eb95-4bb4-8685-6ef61e994caa;
UPDATE cycling.cyclist_name SET comments ='Rides fast, does not get along with others, a real dude' WHERE id = 5b6962dd-3f90-4c93-8f61-eabfa4a803e2;

CREATE CUSTOM INDEX stdanalyzer_idx ON cycling.cyclist_name (comments) USING 'org.apache.cassandra.index.sasi.SASIIndex'
WITH OPTIONS = {
'mode': 'CONTAINS',
'analyzer_class': 'org.apache.cassandra.index.sasi.analyzer.StandardAnalyzer',
'analyzed': 'true',
'tokenization_skip_stop_words': 'and, the, or',
'tokenization_enable_stemming': 'true',
'tokenization_normalize_lowercase': 'true',
'tokenization_locale': 'en'
};


// ***************
// COMPOUND QUERY
// AND
// QUERY ON INDEXED and NON-INDEXES COLUMNS EXAMPLE
// ***************
// narrow down query and use inequality:
// add a row:
ALTER TABLE cycling.cyclist_name ADD age int;
UPDATE cycling.cyclist_name SET age=23 WHERE id=5b6962dd-3f90-4c93-8f61-eabfa4a803e2;
INSERT INTO cycling.cyclist_name (id,age,firstname,lastname) VALUES (8566eb59-07df-43b1-a21b-666a3c08c08a,18,'Marianne','DAAE');


// ***********
// EXAMPLES FOR SECURITY
// **********
// CREATE A ROLE THAT REPRESENTS AN INDIVIDUAL
CREATE ROLE alice WITH PASSWORD = 'enjoyLife' AND LOGIN = true;
// CREATE A ROLE THAT REPRESENTS SOME FUNCTIONALITY
CREATE ROLE cycling_admin WITH PASSWORD = '1234abcd';
// GRANT THE ROLE PERMISSIONS
GRANT ALL PERMISSIONS ON KEYSPACE cycling TO cycling_admin;
// GRANT THE FUNCTIONAL ROLE TO THE INDIVIDUAL ROLE
GRANT cycling_admin TO alice;

CREATE ROLE cycling_analyst WITH PASSWORD = 'zyxw9876';
GRANT SELECT ON TABLE cycling.analysis TO cycling_analyst;
CREATE ROLE hockey_analyst WITH PASSWORD = 'Iget2seeAll';
// GRANT A FUNCTIONAL ROLE TO ANOTHER FUNCTIONAL ROLE
GRANT SELECT ON TABLE hockey.analysis TO hockey_analyst;
GRANT hockey_analyst TO cycling_analyst;
GRANT cyclist_analyst TO jane;

// Give cycling_accounts the right to create roles
GRANT CREATE ON ALL ROLES TO cycling_accounts;
// Give cycling_accounts the right to grant or revoke permissions
GRANT AUTHORIZE ON KEYSPACE cycling TO cycling_accounts;
GRANT cyclist_accounts TO jane;
GRANT cyclist_accounts TO john;

// Added the following table for Alter Table caching example, corresponding data is in data/events.csv

CREATE TABLE cycling.events (
    month int,
    end timestamp,
    class text,
    title text,
    location text,
    start timestamp,
    type text,
    PRIMARY KEY (month, end, class, title)
) WITH CLUSTERING ORDER BY (end ASC, class ASC, title ASC)

// change the caching to hold the last 10 events in a month
ALTER TABLE cycling.events WITH caching = {'keys': 'NONE', 'rows_per_partition': 10 };

// Added the following for javascript function example
CREATE FUNCTION IF NOT EXISTS cycling.left (column TEXT,num int)
RETURNS NULL ON NULL INPUT
RETURNS text
LANGUAGE javascript
AS $$
     /* returns the entire field if num not set
       errors if asterisk is entered instead of
       column name*/
    column.substring(0,num)
   $$;
