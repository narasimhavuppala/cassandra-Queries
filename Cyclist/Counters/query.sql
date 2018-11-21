CREATE TABLE IF NOT EXISTS cycling.EmployeeIds (
  empemail text,
  empId counter,
  PRIMARY KEY ((empemail))
);

UPDATE cycling.EmployeeIds
SET empid = empId + 1
WHERE empemail = 'test@test.com';

select * from  cycling.EmployeeIds;

    --Allows you increment a counter.
    --Only counters can exist in the table besides the partition key columns. No other non-counter non-partition key columns can exist.
    --Can only update counter fields.
