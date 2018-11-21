********************************* Q8:****************************************************/

// SIMPLE USER-DEFINED TYPE
CREATE TYPE IF NOT EXISTS cycling.fullname (
	firstname text,
	lastname text
);

CREATE TABLE IF NOT EXISTS cycling.race_winners (
	race_name text,
	race_position int,
	cyclist_name FROZEN<fullname>,
	PRIMARY KEY (race_name, race_position)
);

INSERT INTO cycling.race_winners ( race_name, race_position, cyclist_name )
VALUES ( 'National Championships South Africa WJ-ITT (CN)', 1, {
	firstname : 'Frances',
	lastname : 'DU TOUT'
} );

INSERT INTO cycling.race_winners ( race_name, race_position, cyclist_name )
VALUES ( 'National Championships South Africa WJ-ITT (CN)', 2, {
	firstname : 'Lynette',
	lastname : 'BENSON'
} );

INSERT INTO cycling.race_winners ( race_name, race_position, cyclist_name )
VALUES ( 'National Championships South Africa WJ-ITT (CN)', 3, {
	firstname : 'Anja',
	lastname : 'GERBER'
} );

INSERT INTO cycling.race_winners ( race_name, race_position, cyclist_name )
VALUES ( 'National Championships South Africa WJ-ITT (CN)', 4, {
	firstname : 'Ame',
	lastname : 'VENTER'
} );

INSERT INTO cycling.race_winners ( race_name, race_position, cyclist_name )
VALUES ( 'National Championships South Africa WJ-ITT (CN)', 5, {
	firstname : 'Danielle',
	lastname : 'VAN NIEKERK'
} );