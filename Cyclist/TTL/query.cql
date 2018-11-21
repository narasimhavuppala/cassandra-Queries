//WITH TTL
INSERT INTO cycling.calendar (race_id, race_name, race_start_date, race_end_date) 
VALUES (200, 'placeholder', '2015-05-27', '2015-05-27') USING TTL 300;

UPDATE cycling.calendar USING TTL 300 
SET race_name = 'dummy' WHERE race_id = 200 AND race_start_date = '2015-05-27' AND race_end_date = '2015-05-27';
