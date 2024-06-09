--==========================================================================================================================--
--================================================ Assignment_09 ===========================================================--
--==========================================================================================================================--

--==========================================================================================================================--
--==================================================== part 1 ==============================================================--
--==========================================================================================================================--

use RouteCompany;

CREATE TABLE Department (
    DeptNo CHAR(2) PRIMARY KEY,
    DeptName VARCHAR(255),
    Location VARCHAR(255)
);

INSERT INTO Department (DeptNo, DeptName, Location) VALUES
('d1', 'Research', 'NY'),
('d2', 'Accounting', 'DS'),
('d3', 'Marketing', 'KW');

CREATE TABLE Employee (
    EmpNo INT PRIMARY KEY,
    EmpFname VARCHAR(255) NOT NULL,
    EmpLname VARCHAR(255) NOT NULL,
    DeptNo CHAR(2),
    Salary DECIMAL(10, 2),
    CONSTRAINT fk_DeptNo FOREIGN KEY (DeptNo) REFERENCES Department(DeptNo),
    CONSTRAINT unique_Salary UNIQUE (Salary)
);

INSERT INTO Employee (EmpNo, EmpFname, EmpLname, DeptNo, Salary) VALUES
(25348, 'Mathew', 'Smith', 'd3', 2500),
(10102, 'Ann', 'Jones', 'd3', 3000),
(18316, 'John', 'Barrymore', 'd1', 2400),
(29346, 'James', 'James', 'd2', 2800),
(9031, 'Lisa', 'Bertoni', 'd2', 4000),
(2581, 'Elisa', 'Hansel', 'd2', 3600),
(28559, 'Sybl', 'Moser', 'd1', 2900);

--========================================================================================================--


--1. Insert a new employee with EmpNo = 11111 in the works_on table:
INSERT INTO Works_on (EmpNo, ProjectNo, Job, Enter_Date) VALUES
(11111, 'p1', 'Clerk', '2007-01-01');

--What happens: This insertion will fail because the 'EmpNo' (11111) does not exist in the 'Employee' table.
--Reason: The 'Works_on' table has a foreign key constraint on 'EmpNo' that references the 'EmpNo' in the 'Employee' table.

-- 2. Change the employee number 10102 to 11111 in the works_on table:
UPDATE Works_on
SET EmpNo = 11111
WHERE EmpNo = 10102;

--What happens: This update will fail if 'EmpNo = 11111' does not exist in the 'Employee' table.
--Reason: The foreign key constraint on 'EmpNo' in the 'Works_on' table ensures that every 'EmpNo' value must exist in the 'Employee' table. 

-- 3. Modify the employee number 10102 in the Employee table to 22222:
UPDATE Employee
SET EmpNo = 22222
WHERE EmpNo = 10102;

--What happens: This update will fail if 'EmpNo = 10102' is referenced in the 'Works_on' table.
--Reason: The 'Works_on' table has a foreign key that references 'EmpNo' in the 'Employee' table. 

-- 4. Delete the employee with id 10102:
DELETE FROM Employee
WHERE EmpNo = 10102;

--What happens: This deletion will fail if 'EmpNo = 10102' is referenced in the 'Works_on' table.
--Reason: The foreign key constraint in the 'Works_on' table ensures that every 'EmpNo' value must have a corresponding row in the 'Employee' table. 

--========================================================================================================--


ALTER TABLE Employee
ADD TelephoneNumber VARCHAR(20);


ALTER TABLE Employee
DROP COLUMN TelephoneNumber;

CREATE SCHEMA Company;
CREATE SCHEMA HumanResource;

-- Move Department table to Company schema
ALTER SCHEMA Company TRANSFER dbo.Department;

-- Move Project table to Company schema
ALTER SCHEMA Company TRANSFER dbo.Project;

-- Move Employee table to HumanResource schema
ALTER SCHEMA HumanResource TRANSFER dbo.Employee;


UPDATE Project
SET Budget = Budget * 1.10
WHERE ProjectNo IN (SELECT ProjectNo FROM Works_on WHERE EmpNo = 10102 AND Job = 'Manager');

UPDATE Department
SET DeptName = 'Sales'
WHERE DeptNo = (SELECT DeptNo FROM Employee WHERE EmpFname = 'James');

UPDATE Department
SET DeptName = 'Sales'
WHERE DeptNo = (SELECT DeptNo FROM Employee WHERE EmpFname = 'James');

UPDATE Works_on
SET Enter_Date = '2007-12-12'
WHERE ProjectNo = 'p1' AND EmpNo IN (SELECT EmpNo FROM Employee WHERE DeptNo = (SELECT DeptNo FROM Department WHERE DeptName = 'Sales'));

DELETE FROM Works_on
WHERE EmpNo IN (SELECT EmpNo FROM Employee WHERE DeptNo = (SELECT DeptNo FROM Department WHERE Location = 'KW'));


--==========================================================================================================================--
--==================================================== part 2 ==============================================================--
--==========================================================================================================================--

use [SD32-Company];

--Create an Audit table with the following structure  
CREATE TABLE Audit (
    ProjectNo CHAR(2),
    UserName VARCHAR(255),
    ModifiedDate DATE,
    Budget_Old DECIMAL(15, 2),
    Budget_New DECIMAL(15, 2)
);

--create TRIGGER user updated the budget column then the project number
CREATE or alter TRIGGER trg_AuditBudgetUpdate
ON hr.Project
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Budget)
    BEGIN
        INSERT INTO AuditTable1 (ProjectNo, UserName, ModifiedDate, Budget_Old, Budget_New)
        SELECT 
            i.ProjectNo,
            SYSTEM_USER, -- This captures the current user
            GETDATE(),
            d.Budget AS Budget_Old,
            i.Budget AS Budget_New
        FROM 
            Inserted i
        INNER JOIN 
            Deleted d ON i.ProjectNo = d.ProjectNo;
    END
END;


-- Update statement to test the trigger
UPDATE hr.Project
SET Budget = 200000
WHERE ProjectNo = 2;

-- Check the AuditTable1 for the new audit record
SELECT * FROM AuditTable1;

--==========================================================================================================================--
--==================================================== part 3 ==============================================================--
--==========================================================================================================================--

use ITI;

-- 1. Create an Index on the Hiredate Column in the Department Table
CREATE CLUSTERED INDEX idx_manager_hiredate ON Department(Manager_hiredate);

--What will happen: it will not run, becouse you Cannot create more than one clustered index on table 'Department'. Drop the existing clustered index 'PK_Department' before creating another.

--if it works: Creating a clustered index on the 'Manager_hiredate' column will sort the data in the 'Department' table based on this column. 
--It helps in faster retrieval of records based on the hire date.


-- 2. Create an Index for Unique Ages in the Student Table
CREATE UNIQUE INDEX idx_unique_age ON Student(St_Age);
--What will happen: it will not run, becouse there is a duplicate ages and names.

--if it works: This will create a unique index on the 'St_Age' column in the 'Student' table, ensuring that all values in this column are unique. 

--========================================================================================================--

-- 3. Create Login and User for RouteStudent
-- Create login
CREATE OR ALTER LOGIN RouteStudent WITH PASSWORD = 1234;

CREATE OR ALTER USER RouteStudent FOR LOGIN RouteStudent;

-- Grant SELECT and INSERT
GRANT SELECT, INSERT ON Student TO RouteStudent;
GRANT SELECT, INSERT ON Course TO RouteStudent;

-- Deny DELETE and UPDATE
DENY DELETE, UPDATE ON Student TO RouteStudent;
DENY DELETE, UPDATE ON Course TO RouteStudent;
