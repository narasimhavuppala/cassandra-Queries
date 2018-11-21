CREATE KEYSPACE killrvideo
WITH replication = {'class':'SimpleStrategy','replication_factor': 2};
USE killrvideo;




// Videos by id
CREATE TABLE IF NOT EXISTS videos (
    videoid uuid,
    userid uuid,
    name text,
    description text,
    location text,
    location_type int,
    preview_image_location text,
    tags set<text>,  //list<text>
    added_date timestamp,
    PRIMARY KEY (videoid)
);


CREATE TABLE IF NOT EXISTS cyclist_teams ( 
id UUID PRIMARY KEY, lastname text, firstname text, teams map<int,text> 
);

INSERT INTO cyclist_teams (id, lastname, firstname, teams) 
VALUES (
  5b6962dd-3f90-4c93-8f61-eabfa4a803e2,
  'VOS', 
  'Marianne', 
  {2015 : 'Rabobank-Liv Woman Cycling Team', 2014 : 'Rabobank-Liv Woman Cycling Team', 2013 : 'Rabobank-Liv Giant', 
    2012 : 'Rabobank Women Team', 2011 : 'Nederland bloeit' }); 
    
    select * from cyclist_teams;