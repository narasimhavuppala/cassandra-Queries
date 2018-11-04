CREATE TABLE IF NOT EXISTS rank_by_year_and_name (
	race_year int,
	race_name text,
	cyclist_name text,
	rank int,
	PRIMARY KEY (( race_year, race_name ), rank)
);

CREATE TABLE IF NOT EXISTS cyclist_category (
	category text,
	points int,
	id UUID,
	lastname text,
	PRIMARY KEY (category, points)
) WITH CLUSTERING ORDER BY ( points DESC );