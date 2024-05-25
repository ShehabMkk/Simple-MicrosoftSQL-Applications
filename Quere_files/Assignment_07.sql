--==========================================================================================================================--
--================================================ Assignment_07 ===========================================================--
--==========================================================================================================================--

--==========================================================================================================================--
--==================================================== part 1 ==============================================================--
--==========================================================================================================================--
use ITI;

--1.Scalar Function to Return Month Name:
CREATE FUNCTION dbo.GetMonthName (@Date DATE)
RETURNS VARCHAR(50) AS
BEGIN 
    RETURN DATENAME(MONTH, @Date)
END

--2.Scalar Function to Return Values Between Two Integers:
CREATE FUNCTION dbo.ValuesBetween (@StartInt INT, @EndInt INT)
RETURNS VARCHAR(MAX) AS
BEGIN
    DECLARE @Result VARCHAR(MAX) = ''
    DECLARE @CurrentInt INT = @StartInt + 1

    WHILE @CurrentInt < @EndInt
    BEGIN
        SET @Result = @Result + CAST(@CurrentInt AS VARCHAR) + ', '
        SET @CurrentInt = @CurrentInt + 1
    END

    IF LEN(@Result) > 0
    BEGIN
        SET @Result = LEFT(@Result, LEN(@Result) - 2) 
    END

    RETURN @Result
END

--3.Table-Valued Function to Return Department Name and Student Full Name:
CREATE FUNCTION dbo.GetStudentDepartmentInfo (@St_Id INT)
RETURNS TABLE
AS
RETURN
(
    SELECT D.Dept_Name, S.St_Fname + ' ' + S.St_Lname AS Full_Name
    FROM Student S
    JOIN Department D ON S.Dept_Id = D.Dept_Id
    WHERE S.St_Id = @St_Id
)

--4.Scalar Function to Return a Message Based on Student Name:
create function dbo.getamessagebyid(@stid int)
returns varchar(200)
as 
begin 
    declare @message varchar(200);

    if not exists (select 1 from student where st_id = @stid)
    begin 
        select @message = 'this id is not available'

    end
    else 
    begin 
    declare @fname varchar(50)
    declare @lname varchar(50)
    select @fname = s.st_fname , @lname = s.st_lname
    from student s 
        where s.st_id= @stid
        if @fname is null and @lname is null
        begin set @message = ' full name is null'  end
    else if @fname is null
    begin set @message = 'first name is null' end
    else if @lname is null 
    begin set @message = 'last name is null' end 
    else 
    begin set @message = 'full name is not null 'end
    end


    return @message;
end

--5.Function to Return Department Name, Manager Name and Hiring Date in Specific Format:
CREATE FUNCTION dbo.GetManagerInfo (@DateFormat INT)
RETURNS TABLE
AS
RETURN
(
    SELECT Dept_Name,Dept_Manager,CASE @DateFormat
            WHEN 1 THEN CONVERT(VARCHAR, Manager_hiredate, 101)  
            WHEN 2 THEN CONVERT(VARCHAR, Manager_hiredate, 103)  
            WHEN 3 THEN CONVERT(VARCHAR, Manager_hiredate, 105)  
            ELSE CONVERT(VARCHAR, Manager_hiredate, 120) 
        END AS Hire_Date
    FROM 
        Department
)

--6.Multi-Statement Table-Valued Function to Return Student Names Based on Input String:
CREATE FUNCTION dbo.GetStudentName (@NameType VARCHAR(50))
RETURNS @Result TABLE (Name VARCHAR(100))
AS
BEGIN
    IF @NameType = 'first name'
    BEGIN
        INSERT INTO @Result (Name)
        SELECT ISNULL(St_Fname, '') AS Name
        FROM Student
    END
    ELSE IF @NameType = 'last name'
    BEGIN
        INSERT INTO @Result (Name)
        SELECT ISNULL(St_Lname, '') AS Name
        FROM Student
    END
    ELSE IF @NameType = 'full name'
    BEGIN
        INSERT INTO @Result (Name)
        SELECT ISNULL(St_Fname, '') + ' ' + ISNULL(St_Lname, '') AS Full_Name
        FROM Student
    END

    RETURN
END

--7.Function to Display All Employees in a Project:
USE MyCompany;

CREATE FUNCTION dbo.GetEmployeesInProject (@ProjectNumber INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        E.SSN, 
        E.Fname
    FROM 
        Employee E
    JOIN 
        Works_for W ON E.SSN = W.ESSn
    WHERE 
        W.Pno = @ProjectNumber
)

--==========================================================================================================================--
--==================================================== part 2 ==============================================================--
--==========================================================================================================================--
use ITI;

--1.View to Display Student's Full Name and Course Name for Grades More Than 50:
CREATE VIEW StudentsWithHighGrades AS
SELECT S.St_Fname + ' ' + S.St_Lname AS Full_Name, C.Crs_Name
FROM Student S
JOIN Stud_Course SC ON S.St_Id = SC.St_Id
JOIN Course C ON SC.Crs_Id = C.Crs_Id
WHERE SC.Grade > 50;

--2.Encrypted View to Display Manager Names and Topics They Teach:
CREATE VIEW ManagerTopicsWITH with encryption AS
SELECT D.Dept_Manager AS Manager_Name,T.Top_Name AS Topic_Name
FROM Department D
JOIN Instructor I ON D.Dept_Id = I.Dept_Id
JOIN Ins_Course IC ON I.Ins_Id = IC.Ins_Id
JOIN Course C ON IC.Crs_Id = C.Crs_Id
JOIN Topic T ON C.Top_Id = T.Top_Id;

--3.View to Display Instructor Name, Department Name for 'SD' or 'Java' Department with Schema Binding:
CREATE VIEW InstructorsInSpecificDepartments WITH SCHEMABINDING AS
SELECT I.Ins_Name,D.Dept_Name
FROM dbo.Instructor I
JOIN dbo.Department D ON I.Dept_Id = D.Dept_Id
WHERE D.Dept_Name IN ('SD', 'Java');

--4.View to Display Project Name and Number of Employees Working on It:
use MyCompany;

CREATE VIEW ProjectEmployeeCount AS
SELECT P.Pname,COUNT(W.ESSn) AS NumberOfEmployees
FROM Project P
JOIN Works_for W ON P.Pnumber = W.Pno
GROUP BY P.Pname;



--==========================================================================================================================--
use [SD32-Company];

DROP view v_clerk;
DROP view v_without_budget;
DROP view v_project_p2;
DROP view v_dept;
DROP view v_emp_d2;

--1.Create a view named “v_clerk” that will display employee Number, project Number, and the date of hiring of all the jobs of the type 'Clerk':
CREATE VIEW v_clerk AS
SELECT EmpNo, ProjectNo, Enter_Date
FROM Works_on
WHERE Job = 'Clerk';

--2.Create view named “v_without_budget” that will display all the projects data without budget:
CREATE VIEW v_without_budget AS
SELECT ProjectNo, ProjectName
FROM hr.Project
WHERE Budget IS NULL;

--3.Create view named “v_count” that will display the project name and the Number of jobs in it:
CREATE VIEW v_count AS
SELECT P.ProjectName, COUNT(W.Job) AS NumberOfJobs
FROM hr.Project P
JOIN Works_on W ON P.ProjectNo = W.ProjectNo
GROUP BY P.ProjectName;

--4.Create view named ”v_project_p2” that will display the emp#s for the project# ‘p2’. (use the previously created view “v_clerk”):
CREATE VIEW v_project_p2 AS
SELECT EmpNo
FROM v_clerk
WHERE ProjectNo = 'p2';

--5.Modify the view named “v_without_budget” to display all DATA in project p1 and p2:
DROP VIEW v_without_budget;

CREATE VIEW v_without_budget AS
SELECT *
FROM hr.Project
WHERE ProjectNo IN ('p1', 'p2');

--6.Delete the views “v_clerk” and “v_count”:
DROP VIEW v_clerk;
DROP VIEW v_count;

--7.Create view that will display the emp# and emp last name who works on deptNumber is ‘d2’:
INSERT into hr.Employee (EmpNo,EmpFname,EmpLname,DeptNo,Salary) 
VALUES (12345,'shehab','mkk',2,100000);

INSERT into hr.Employee (EmpNo,EmpFname,EmpLname,DeptNo,Salary) 
VALUES (22346,'Johnathan','Jotaro',2,9050);

CREATE VIEW v_emp_d2 AS
SELECT E.EmpNo, E.EmpLname
FROM hr.Employee E
WHERE E.DeptNo = '2';

--8.Display the employee lastname that contains letter “J” (Use the previous view created in Q#7):
SELECT EmpLname
FROM dbo.v_emp_d2
WHERE EmpLname LIKE '%J%';

--9.Create view named “v_dept” that will display the department# and department name:
CREATE VIEW v_dept AS
SELECT DeptNo, DeptName
FROM Department;

