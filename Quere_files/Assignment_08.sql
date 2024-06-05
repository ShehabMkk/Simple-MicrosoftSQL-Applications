--==========================================================================================================================--
--================================================ Assignment_08 ===========================================================--
--==========================================================================================================================--

--==========================================================================================================================--
--==================================================== part 1 ==============================================================--
--==========================================================================================================================--

use ITI;
--1. Create a view “V1” that displays student data for students who live in Alex or Cairo.
CREATE VIEW V1 AS
SELECT *
FROM Student
WHERE St_Address IN ('Alex', 'Cairo');

CREATE VIEW V1 AS
SELECT *
FROM Student
WHERE St_Address IN ('Alex', 'Cairo')
WITH CHECK OPTION;

--==========================================================================================================================--

use [SD32-Company];
drop view v_dept;

--1. Create view named “v_dept” that will display the department# and department name.
CREATE VIEW v_dept AS
SELECT DeptNo, DeptName
FROM Department;

--2. Using the previous view, try to enter new department data where dept# is 'd4' and dept name is 'Development'.
INSERT INTO v_dept (DeptNo, DeptName)
VALUES (4, 'Development');

--3. Create view named “v_2006_check” that will display employee number, the project number where he works, and the date of joining the project which must be from January 1st to December 31st, 2006.
drop VIEW v_2006_check;

CREATE VIEW v_2006_check AS
SELECT EmpNo, ProjectNo, Enter_Date
FROM Works_on
WHERE Enter_Date BETWEEN '2006-01-01' AND '2006-12-31'
WITH CHECK OPTION;

--==========================================================================================================================--
--==================================================== part 2 ==============================================================--
--==========================================================================================================================--

use ITI;
--1. Create a stored procedure to show the number of students per department.
CREATE PROCEDURE ShowStudentCountPerDept AS
BEGIN
    SELECT Dept_Id, COUNT(*) AS StudentCount
    FROM Student
    GROUP BY Dept_Id;
END;

--2. Create a stored procedure that checks the number of employees in project 100.
use MyCompany;

CREATE PROCEDURE CheckProject100Employees AS
BEGIN
    DECLARE @EmpCount INT;
    
    SELECT @EmpCount = COUNT(*)
    FROM Works_on
    WHERE Pnumber = 100;
    
    IF @EmpCount >= 3
        PRINT 'The number of employees in the project 100 is 3 or more';
    ELSE
    BEGIN
        PRINT 'The following employees work for the project 100';
        SELECT E.Fname, E.Lname
        FROM Employee E
        JOIN Works_on W ON E.SSN = W.ESSN
        WHERE W.Pnumber = 100;
    END
END;

--3. Create a stored procedure for replacing an old employee with a new one in a project.
CREATE PROCEDURE ReplaceEmployeeInProject
    @OldEmpNo CHAR(9),
    @NewEmpNo CHAR(9),
    @ProjectNo INT
AS
BEGIN
    UPDATE Works_on
    SET ESSN = @NewEmpNo
    WHERE ESSN = @OldEmpNo AND Pnumber = @ProjectNo;
END;

--==========================================================================================================================--
--==================================================== part 3 ==============================================================--
--==========================================================================================================================--

--1. Create a stored procedure that calculates the sum of a given range of numbers.
CREATE PROCEDURE CalculateSum
    @StartNum INT,
    @EndNum INT
AS
BEGIN
    DECLARE @Sum INT = 0;
    DECLARE @CurrentNum INT = @StartNum;
    
    WHILE @CurrentNum <= @EndNum
    BEGIN
        SET @Sum = @Sum + @CurrentNum;
        SET @CurrentNum = @CurrentNum + 1;
    END
    
    PRINT 'Sum: ' + CAST(@Sum AS VARCHAR);
END;

--2. Create a stored procedure that calculates the area of a circle given its radius.
CREATE PROCEDURE CalculateArea
    @Radius FLOAT
AS
BEGIN
    DECLARE @Area FLOAT;
    SET @Area = PI() * @Radius * @Radius;
    PRINT 'Area: ' + CAST(@Area AS VARCHAR);
END;

--3. Create a stored procedure that calculates the age category based on a person's age.
CREATE PROCEDURE CalculateAgeCategory
    @Age INT
AS
BEGIN
    DECLARE @Category VARCHAR(10);
    
    IF @Age < 18
        SET @Category = 'Child';
    ELSE IF @Age >= 18 AND @Age < 60
        SET @Category = 'Adult';
    ELSE
        SET @Category = 'Senior';
    
    PRINT 'Category: ' + @Category;
END;

--4. Create a stored procedure that determines the maximum, minimum, and average of a given set of numbers.
CREATE PROCEDURE CalculateStats
    @Numbers VARCHAR(MAX)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    
    SET @SQL = '
    SELECT 
        MAX(Value) AS MaxValue, 
        MIN(Value) AS MinValue, 
        AVG(Value) AS AvgValue
    FROM (
        SELECT CAST(value AS INT) AS Value
        FROM STRING_SPLIT(@Numbers, '','')
    ) AS NumberValues';
    
    EXEC sp_executesql @SQL, N'@Numbers VARCHAR(MAX)', @Numbers;
END;

--==========================================================================================================================--
--==================================================== part 4 ==============================================================--
--==========================================================================================================================--

use ITI;

--1. Create a trigger to prevent insertion into the Department table.
CREATE TRIGGER PreventInsertOnDepartment
ON Department
INSTEAD OF INSERT
AS
BEGIN
    PRINT 'You cannot insert a new record into the Department table.';
END;

--Create a table named “StudentAudit”.
CREATE TABLE StudentAudit (
    ServerUserName NVARCHAR(100),
    Date DATETIME,
    Note NVARCHAR(255)
);

--2. Create a trigger on the Student table to add a row in the StudentAudit table after insert.
CREATE TRIGGER AfterInsertOnStudent
ON Student
AFTER INSERT
AS
BEGIN
    DECLARE @UserName NVARCHAR(100);
    DECLARE @Date DATETIME;
    DECLARE @Note NVARCHAR(255);
    
    SELECT @UserName = SYSTEM_USER, @Date = GETDATE();
    
    INSERT INTO StudentAudit (ServerUserName, Date, Note)
    SELECT @UserName, @Date, 
           @UserName + ' Inserted New Row with Key = ' + CAST(inserted.St_Id AS NVARCHAR) + ' in table Student'
    FROM inserted;
END;

--3. Create a trigger on the Student table instead of delete to add a row in the StudentAudit table.
CREATE TRIGGER InsteadOfDeleteOnStudent
ON Student
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @UserName NVARCHAR(100);
    DECLARE @Date DATETIME;
    DECLARE @Note NVARCHAR(255);
    
    SELECT @UserName = SYSTEM_USER, @Date = GETDATE();
    
    INSERT INTO StudentAudit (ServerUserName, Date, Note)
    SELECT @UserName, @Date, 
           'Try to delete Row with id = ' + CAST(deleted.St_Id AS NVARCHAR)
    FROM deleted;
END;

--==========================================================================================================================--

use MyCompany;

--4. Create a trigger that prevents the insertion into the Employee table in March.
CREATE TRIGGER PreventInsertInMarch
ON Employee
BEFORE INSERT
AS
BEGIN
    IF MONTH(GETDATE()) = 3
    BEGIN
        RAISERROR ('Inserting into the Employee table is not allowed in March.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

