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

