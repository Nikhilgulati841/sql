CREATE TABLE Test1 (
    ID int identity(100,1),
    FirstName VARCHAR(10),
    LastName VARCHAR(10),
    Age int

    
)

INSERT INTO Test1 (ID, FirstName, LastName, Age) VALUES
    (1, 'John', 'Doe', 30),
    (2, 'Jane', 'Smith', 25),
    (3, 'Peter', 'Jones', 40);


SELECT * FROM Test1;

SELECT FirstName, LastName FROM Test1 WHERE Age = 40;


-- This is a comment in SQL
-- It's possible there's an error in your MSSQL query due to:
-- 1. Syntax errors: Misspellings, missing keywords, incorrect punctuation.
-- 2. Object not found: Table or column names don't exist or are misspelled.
-- 3. Permissions: The user executing the query doesn't have the necessary permissions.
-- 4. Data type mismatch: Trying to insert a string into an integer column, for example.
-- 5. Constraints violation: Violating a primary key, unique, or foreign key constraint.
-- 6. Transaction issues: Uncommitted transactions or deadlocks.
-- 7. Server issues: Database server is down or experiencing high load.

-- To help diagnose the error, you would typically look at the error message provided by MSSQL.
-- The error message usually gives a good indication of what went wrong.



-- This is a comment in SQL
-- It's possible there's an error in your MSSQL query due to:
-- 1. Syntax errors: Misspellings, missing keywords, incorrect punctuation.
-- 2. Object not found: Table or column names don't exist or are misspelled.
-- 3. Permissions: The user executing the query doesn't have the necessary permissions.
-- 4. Data type mismatch: Trying to insert a string into an integer column, for example.
-- 5. Constraints violation: Violating a primary key, unique, or foreign key constraint.
-- 6. Transaction issues: Uncommitted transactions or deadlocks.
-- 7. Server issues: Database server is down or experiencing high load.

-- To help diagnose the error, you would typically look at the error message provided by MSSQL.
-- The error message usually gives a good indication of what went wrong.
