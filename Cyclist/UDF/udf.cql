CREATE OR REPLACE FUNCTION cycling.calcu(input int)
    CALLED ON NULL INPUT
    RETURNS int
    LANGUAGE java
    AS $$return (2 + input);$$;
    
SELECT cycling.calcu(race_id),race_id from cycling.calendar;