CREATE TABLE IF NOT EXISTS cyclist_name 
( id UUID PRIMARY KEY, 
  lastname text, 
  firstname text
);

CREATE TABLE IF NOT EXISTS cyclist_name (
	id UUID, 
	lastname text, 
	firstname text, 
	PRIMARY KEY (id)
);