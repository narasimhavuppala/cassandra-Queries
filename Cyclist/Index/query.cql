// If you want to search by age, an index can be added
CREATE INDEX IF NOT EXISTS c_age 
ON cycling.cyclist_id (age);

select * from cycling.cyclist_id
where age = 18;