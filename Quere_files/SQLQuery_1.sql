--=============================================================================================================================--
--========================================================== Assignment 05 ====================================================--
--=============================================================================================================================--

--===============(part 1)=================--
use ITI;

--1.Retrieve number of students who have a value in their age
SELECT COUNT(St_Age) AS Students_With_Age
FROM Student

--2.Display number of courses for each topic name
SELECT T.Top_Name , COUNT(C.Crs_Id) AS Course_Count
FROM Course AS C INNER JOIN Topic AS T ON C.Top_Id = T.Top_Id
GROUP BY Top_Name;

--3.Select Student first name and the data of his supervisor
SELECT S.St_Fname , Sup.*
FROM Student AS S JOIN Student as Sup ON S.St_super= Sup.St_Id

--4.Display student with the following Format
SELECT ISNULL(Student.St_Id,'NOT FOUND') AS St_Id,ISNULL(CONCAT(Student.St_Fname , ' ' , Student.St_Lname),'NOT FOUND') AS Full_Name,ISNULL(Department.Dept_Name,'NOT FOUND')
FROM Student
INNER JOIN Department ON Student.Dept_Id = Department.Dept_Id;


--5.Display instructor name and his salary but if there is no salary display value ‘0000’
SELECT Ins_Name, ISNULL(Salary, '0000') AS Salary
FROM Instructor;

--6.Select Supervisor first name and the count of students who supervises on them
SELECT Sup.St_Fname , COUNT(s.St_Id)
FROM Student AS S JOIN Student as Sup ON S.St_super= Sup.St_Id
GROUP BY Sup.St_Fname
--7.Display max and min salary for instructors
SELECT MAX(Salary) AS Max_Salary, MIN(Salary) AS Min_Salary
FROM Instructor;

--8.Select Average Salary for instructors
SELECT AVG(Salary) AS Average_Salary
FROM Instructor;




--==================================================================================================================--



--==============(part 2)=============--

use MyCompany;

-- DQL Queries:

--1. Total Hours per Week per Project:
SELECT P.Pname, SUM(W.Hours) AS Total_Weekly_Hours
FROM Project AS P INNER JOIN Works_for AS W ON P.Pnumber = W.Pno
GROUP BY P.Pname;

--2. Department Salary Statistics:
SELECT D.Dname, MAX(E.Salary) AS Max_Salary, MIN(E.Salary) AS Min_Salary, AVG(E.Salary) AS Avg_Salary
FROM Departments AS D INNER JOIN Employee AS E ON D.Dnum = E.Dno
GROUP BY D.Dnum, D.Dname;

--3. Employee Project List by Department:
SELECT D.Dname, E.Fname, E.Lname, P.Pname
FROM Employee AS E INNER JOIN Works_for AS W ON E.SSN = W.ESSN 
INNER JOIN Project AS P ON W.Pno = P.Pnumber 
INNER JOIN Departments AS D ON E.Dno = D.Dnum
ORDER BY D.Dname, E.Lname, Fname;

--4.update all salaries of employees who work in Project ‘Al Rabwah’ by 30%
UPDATE E 
SET E.Salary = E.Salary * 1.3  
FROM Employee AS E
INNER JOIN Works_for AS W ON E.SSN = W.ESSN
INNER JOIN Project AS P ON W.Pno = P.Pnumber
WHERE P.Pname = 'AL Rabwah';


--=====================================================================--


--## DML Queries:

--(1)
INSERT INTO Departments (Dnum, Dname, MGRSSN, [MGRStart Date])
VALUES (100, 'DEPT IT', 112233, '2006-11-01');

--(2)
--a)
INSERT INTO Employee (Fname,Lname,SSN,Sex,Dno)
VALUES ('Shehab','MKK',102672,'M',20);

UPDATE Employee
SET Dno=100
WHERE SSN = 968574;

UPDATE Departments
SET MGRSSN = 968574  
WHERE  MGRSSN = 112233; 

--b. Update Your Record (SSN=102672):
UPDATE Departments
SET MGRSSN = 102672  
WHERE  MGRSSN = 968574;  

--c. Update Employee Teamwork (SSN=102660):
UPDATE Employee
SET Dno = 20  
WHERE SSN = 102660; 

--(3)
UPDATE DEPARTMENTS SET MGRSSN = NULL WHERE MGRSSN = 223344
DELETE Dependent WHERE ESSN = 223344
UPDATE EMPLOYEE SET SUPERSSN = NULL WHERE SUPERSSN = 223344
DELETE FROM WORKS_FOR WHERE ESSN = 223344
DELETE EMPLOYEE WHERE SSN = 223344



--==================================================================================================================--



--=============(part 3)=============--

use MyCompany;


--1.Retrieve employees in department 10 working on "AL Rabwah" project (>= 10 hours):
SELECT E.Fname, E.Lname
FROM Employee AS E
INNER JOIN Works_for AS W ON E.SSN = W.ESSN
INNER JOIN Project AS P ON W.Pno = P.Pnumber
WHERE E.Dno = 10 AND P.Pname = 'AL Rabwah' AND W.Hours >= 10;

--2.Find employees directly supervised by Kamel Mohamed (SSN=223344):
SELECT E.Fname, E.Lname
FROM Employee AS E
WHERE E.SuperSSN = 223344;  

--3.Display All Data of the managers:
SELECT E.*, D.Dname
FROM Employee AS E
INNER JOIN Departments AS D ON E.Dno = D.Dnum
WHERE E.SSN IN (SELECT MGRSSN FROM Departments);  

--4.Retrieve employee names and project names, sorted by project name:
SELECT E.Fname, E.Lname, P.Pname
FROM Employee AS E
INNER JOIN Works_for AS W ON E.SSN = W.ESSN
INNER JOIN Project AS P ON W.Pno = P.Pnumber
ORDER BY P.Pname;

--5.Find project details for projects in Cairo City:
SELECT P.Pnumber, D.Dname, E.Lname, E.Address, E.Bdate
FROM Project AS P
INNER JOIN Departments AS D ON P.Dnum = D.Dnum
INNER JOIN Employee AS E ON D.MGRSSN = E.SSN
WHERE P.City = 'Cairo';

--6.Display all employee data and dependent data (even with no dependents):
SELECT E.*, DEP.*
FROM Employee AS E
LEFT JOIN Dependent AS DEP ON E.SSN = DEP.ESSN
