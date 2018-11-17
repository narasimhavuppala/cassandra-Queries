
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

-- Primary Key =Mandatory Partion Key + Optional Clustering keys 
CREATE TABLE IF NOT EXISTS cyclist_category (
	category text,
	points int,
	id UUID,
	lastname text,
	PRIMARY KEY (category, points)  -- Category is Partion key,points is Clustering columns
) WITH CLUSTERING ORDER BY ( points DESC );


CREATE TABLE IF NOT EXISTS rank_by_year_and_name (
	race_year int,
	race_name text,
	cyclist_name text,
	rank int,
	PRIMARY KEY (( race_year, race_name ), rank)  --composite partion key
);

