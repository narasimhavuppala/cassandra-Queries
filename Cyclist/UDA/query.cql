// CREATE UDA that computes the average value
//CREATE TABLE WITH SIMPLE PRIMARY KEY: PARTITION KEY + 2 CLUSTERING COLUMNS
CREATE OR REPLACE FUNCTION cycling.avgState ( state tuple<int, bigint>, val int ) 
CALLED ON NULL INPUT RETURNS
tuple<int, bigint>LANGUAGE java AS
'if (val !=null) { state.setInt(0, state.getInt(0)+1); state.setLong(1, state.getLong(1)+val.intValue()); } return state;';

CREATE OR REPLACE FUNCTION cycling.avgFinal ( state tuple<int, bigint>) CALLED ON NULL
 INPUT RETURNS double LANGUAGE
java AS
'double r = 0; if (state.getInt(0) == 0) return null; r = state.getLong(1); r/= state.getInt(0); return Double.valueOf(r);';

CREATE AGGREGATE cycling.average ( int ) SFUNC avgState STYPE tuple<int, bigint>FINALFUNC avgFinal INITCOND ( 0, 0 );

CREATE TABLE cycling.team_average (
	team_name text,
	cyclist_name text,
	cyclist_time_sec int,
	race_title text,
	PRIMARY KEY (team_name, race_title, cyclist_name)
);

INSERT INTO cycling.team_average ( team_name, cyclist_name, cyclist_time_sec, race_title )
VALUES ( 'UnitedHealthCare Pro Cycling Womens Team', 'Katie HALL', 11449,
'Amgen Tour of California Women''s Race presented by SRAM - Stage 1 - Lake Tahoe > Lake Tahoe' );

INSERT INTO cycling.team_average ( team_name, cyclist_name, cyclist_time_sec, race_title )
VALUES ( 'UnitedHealthCare Pro Cycling Womens Team', 'Linda VILLUMSEN', 11485,
'Amgen Tour of California Women''s Race presented by SRAM - Stage 1 - Lake Tahoe > Lake Tahoe' );

INSERT INTO cycling.team_average ( team_name, cyclist_name, cyclist_time_sec, race_title )
VALUES ( 'UnitedHealthCare Pro Cycling Womens Team', 'Hannah BARNES', 11490,
'Amgen Tour of California Women''s Race presented by SRAM - Stage 1 - Lake Tahoe > Lake Tahoe' );

INSERT INTO cycling.team_average ( team_name, cyclist_name, cyclist_time_sec, race_title )
VALUES ( 'Velocio-SRAM', 'Alena AMIALIUSIK', 11451,
'Amgen Tour of California Women''s Race presented by SRAM - Stage 1 - Lake Tahoe > Lake Tahoe' );

INSERT INTO cycling.team_average ( team_name, cyclist_name, cyclist_time_sec, race_title )
VALUES ( 'Velocio-SRAM', 'Trixi WORRACK', 11453,
'Amgen Tour of California Women''s Race presented by SRAM - Stage 1 - Lake Tahoe > Lake Tahoe' );

INSERT INTO cycling.team_average ( team_name, cyclist_name, cyclist_time_sec, race_title )
VALUES ( 'TWENTY16 presented by Sho-Air', 'Lauren KOMANSKI', 11451,
'Amgen Tour of California Women''s Race presented by SRAM - Stage 1 - Lake Tahoe > Lake Tahoe' );
