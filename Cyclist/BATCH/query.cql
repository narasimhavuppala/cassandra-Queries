
// BATCH statement
// Insert data into multiple tables using a BATCH statement
// Note that what is inserted is data for the SAME cyclist, to two tables
BEGIN BATCH
	INSERT INTO cycling.cyclist_name ( id, lastname, firstname )
	VALUES ( c7fceba0-c141-4207-9494-a29f9809de6f, 'PIETERS', 'Amy' );

	INSERT INTO cycling.cyclist_id ( lastname, firstname, age, id )
	VALUES ( 'PIETERS', 'Amy', 23, c7fceba0-c141-4207-9494-a29f9809de6f );

APPLY BATCH;

// NOT A QUERY, JUST AN EXAMPLE:
// BATCH statement MISUSE
// Insert data into same table, but involves multiple nodes due to partition key = id
BEGIN BATCH
	INSERT INTO cycling.cyclist_name ( id, lastname, firstname )
	VALUES ( 6d5f1663-89c0-45fc-8cfd-60a373b01622, 'HOSKINS', 'Melissa' );

	INSERT INTO cycling.cyclist_name ( id, lastname, firstname )
	VALUES ( 38ab64b6-26cc-4de9-ab28-c257cf011659, 'FERNANDES', 'Marcia' );

	INSERT INTO cycling.cyclist_name ( id, lastname, firstname )
	VALUES ( 9011d3be-d35c-4a8d-83f7-a3c543789ee7, 'NIEWIADOMA', 'Katarzyna' );

	INSERT INTO cycling.cyclist_name ( id, lastname, firstname )
	VALUES ( 95addc4c-459e-4ed7-b4b5-472f19a67995, 'ADRIAN', 'Vera' );

APPLY BATCH;

// NOT A QUERY, JUST AN EXAMPLE:
// BATCH statement WITH CONDITIONAL "IF NOT EXISTS"
// EXAMPLE USES CYCLIST'S EXPENSES
CREATE TABLE cycling.cyclist_expenses (
	cyclist_name text,
	balance float STATIC,
	expense_id int,
	amount float,
	description text,
	paid boolean,
	PRIMARY KEY (cyclist_name, expense_id)
);

BEGIN BATCH
	INSERT INTO cycling.cyclist_expenses ( cyclist_name, balance )
	VALUES ( 'Vera ADRIAN', 0 ) IF NOT EXISTS;

	INSERT INTO cycling.cyclist_expenses ( cyclist_name, expense_id, amount, description, paid )
	VALUES ( 'Vera ADRIAN', 1, 7.95, 'Breakfast', false );

APPLY BATCH;

UPDATE cycling.cyclist_expenses SET balance = -7.95
WHERE cyclist_name = 'Vera ADRIAN' IF balance = 0;

// NOT A QUERY, JUST AN EXAMPLE:
// BATCH statement WITH CONDITIONAL "IF"
BEGIN BATCH
	INSERT INTO cycling.cyclist_expenses ( cyclist_name, expense_id, amount, description, paid )
	VALUES ( 'Vera ADRIAN', 2, 13.44, 'Lunch', true );

	INSERT INTO cycling.cyclist_expenses ( cyclist_name, expense_id, amount, description, paid )
	VALUES ( 'Vera ADRIAN', 3, 25.00, 'Dinner', false );

	UPDATE cycling.cyclist_expenses SET balance = -32.95
	WHERE cyclist_name = 'Vera ADRIAN' IF balance = -7.95;

APPLY BATCH;

//using a different timestamp for each request
BEGIN BATCH
	INSERT INTO cycling.cyclist_expenses ( cyclist_name, expense_id, amount, description, paid )
	VALUES ( 'Vera ADRIAN', 2, 13.44, 'Lunch', true )
	USING TIMESTAMP 1481124356754405;

	INSERT INTO cycling.cyclist_expenses ( cyclist_name, expense_id, amount, description, paid )
	VALUES ( 'Vera ADRIAN', 3, 25.00, 'Dinner', false )
	USING TIMESTAMP 1479922052163972;

APPLY BATCH;

//using a client provided the same timestamp for all requests
BEGIN BATCH USING TIMESTAMP 1481124356754405
	INSERT INTO cycling.cyclist_expenses ( cyclist_name, expense_id, amount, description, paid )
	VALUES ( 'Vera ADRIAN', 2, 13.44, 'Lunch', true );

	INSERT INTO cycling.cyclist_expenses ( cyclist_name, expense_id, amount, description, paid )
	VALUES ( 'Vera ADRIAN', 3, 25.00, 'Dinner', false );

APPLY BATCH;

//using the cassandra provided the same timestamp for all requests
BEGIN BATCH USING TIMESTAMP INSERT INTO cycling.cyclist_expenses ( cyclist_name, expense_id, amount, description, paid )
	VALUES ( 'Vera ADRIAN', 2, 13.44, 'Lunch', true );

	INSERT INTO cycling.cyclist_expenses ( cyclist_name, expense_id, amount, description, paid )
	VALUES ( 'Vera ADRIAN', 3, 25.00, 'Dinner', false );

APPLY BATCH;

//query to show the time the records were written

// LWT in batches with timestamps fail
BEGIN BATCH USING TIMESTAMP 1481124356754405
	INSERT INTO cycling.cyclist_expenses ( cyclist_name, expense_id, amount, description, paid )
	VALUES ( 'Vera ADRIAN', 2, 13.44, 'Lunch', true );

	INSERT INTO cycling.cyclist_expenses ( cyclist_name, expense_id, amount, description, paid )
	VALUES ( 'Vera ADRIAN', 3, 25.00, 'Dinner', false ) IF NOT EXISTS;

APPLY BATCH;

// NOT A QUERY, JUST AN EXAMPLE:
// BATCH statement WITH CONDITIONAL "IF"
BEGIN BATCH
	UPDATE cycling.cyclist_expenses SET balance = 0
	WHERE cyclist_name = 'Vera ADRIAN' IF balance = -32.95;

	UPDATE cycling.cyclist_expenses SET paid = true
	WHERE cyclist_name = 'Vera ADRIAN' AND expense_id = 1 IF paid = false;

	UPDATE cycling.cyclist_expenses SET paid = true
	WHERE cyclist_name = 'Vera ADRIAN' AND expense_id = 3 IF paid = false;

 
//APPLY BATCH;