
// NOT A QUERY, JUST AN EXAMPLE
// LIGHTWEIGHT TRANSACTION
// Insert or update information using a conditional statement
INSERT INTO cycling.cyclist_name ( id, lastname, firstname )
VALUES ( c4b65263-fe58-4846-83e8-f0e1c13d518f, 'RATTO', 'Rissella' ) 
IF NOT EXISTS;

// UPDATE USING LIGHTWEIGHT TRANSACTION
UPDATE cycling.cyclist_name SET firstname = 'Rossella'
WHERE id = c4b65263-fe58-4846-83e8-f0e1c13d518f 
IF lastname = 'RATTO';
