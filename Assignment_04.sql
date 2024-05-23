--part 1
--1) From The Previous Assignment:
USE Route_Assignment;

--Airline
INSERT INTO Airline (Airline_NAME, AL_Id, Airline_Address, CONT_Person)
VALUES ('Evergreen Airlines', 1001, '123 Main St, Seattle, WA', 12345);

INSERT INTO Airline (Airline_NAME, AL_Id, Airline_Address, CONT_Person)
VALUES ('Sky High Inc.', 1002, '456 Elm St, New York, NY', 54321);

--Aircraft
INSERT INTO Aircraft (AC_Id, Capacity, Model, Maj_pilot, Assistant, Host1, Host2, AL_Id)
VALUES (2001, 200, 'Boeing 777', 'John Smith', 'Jane Doe', 'Mary Jones', 'David Lee', 1001);

INSERT INTO Aircraft (AC_Id, Capacity, Model, Maj_pilot, Assistant, Host1, Host2, AL_Id)
VALUES (2002, 150, 'Airbus A320', 'Peter Parker', 'Susan Storm', 'Charles Xavier', 'Erik Lehnsherr', 1002);

--Airline_PHONES
INSERT INTO Airline_PHONES (AL_Id, Phones)
VALUES (1001, 1234567890);

INSERT INTO Airline_PHONES (AL_Id, Phones)
VALUES (1002, 9876543210);

--Transactions
INSERT INTO Transactions (AL_Id, T_Id, T_Description, Amount, T_DATE)
VALUES (1001, 3001, 'Aircraft Purchase', 10000000.00, '2024-05-15');

INSERT INTO Transactions (AL_Id, T_Id, T_Description, Amount, T_DATE)
VALUES (1002, 3002, 'Fuel Refill', 500000.00, '2024-05-14');

--Employee
INSERT INTO Employee (AL_Id, E_Id, E_NAME, E_ADDRESS, GENDER, BDATE, POSITION)
VALUES (1001, 4001, 'Michael Jordan', '555 Oak St, Chicago, IL', 'M', '1963-02-17', 'Pilot');

INSERT INTO Employee (AL_Id, E_Id, E_NAME, E_ADDRESS, GENDER, BDATE, POSITION)
VALUES (1002, 4002, 'Serena Williams', '777 Beach Blvd, Los Angeles, CA', 'F', '1981-09-26', 'Flight Attendant');

--Employee_Qualifications
INSERT INTO Employee_Qualifications (E_Id, Qualifications)
VALUES (4001, 'Commercial Pilot License');

INSERT INTO Employee_Qualifications (E_Id, Qualifications)
VALUES (4002, 'First Aid Certification');

--Route
INSERT INTO Route (R_Id, distination, distance, origin, classification)
VALUES (5001, 'New York, NY', 2500, 'Seattle, WA', 'Domestic');

INSERT INTO Route (R_Id, distination, distance, origin, classification)
VALUES (5002, 'Tokyo, Japan', 6000, 'Los Angeles, CA', 'International');

--AC_Routes
INSERT INTO AC_Routes (AC_Id, R_Id, Departure, Price, NUM_OF_PASS, ARRIVAL)
VALUES (2001, 5001, '2024-05-17 10:00:00', 500.00, 150, '2024-05-17 14:00:00');

INSERT INTO AC_Routes (AC_Id, R_Id, Departure, Price, NUM_OF_PASS, ARRIVAL)
VALUES (2002, 5002, '2024-05-18 18:00:00', 2000.00, 100, '2024-08-1 17:00:00');


--2) Data Manipulating Language: 
use ITI;
--(1)
INSERT INTO Student (St_Id, St_Fname, St_Lname, Dept_Id)
VALUES (54, 'Shehab', 'Kamal', 30);

--(2)
INSERT INTO Instructor (Ins_Id, Ins_Name, Dept_Id, Salary)
VALUES (55, 'Ahmed', 30, 4000);

--(3)
UPDATE Instructor
SET Salary = Salary * 1.2
WHERE Dept_Id = 30;



----------------------------------------------------------------------------------------------------------------------------
--part 2
use MyCompany;

--(1)
SELECT * FROM Employee;

--(2)
SELECT Fname, Lname, Salary, Dno FROM Employee;

--(3)
SELECT P.Pname, P.Plocation, P.Dnum
FROM Project as P;  

--(4)
SELECT Fname,Lname AS FullName, Salary * 0.1 AS ANNUAL_COMM
FROM Employee;

--(5)
SELECT SSN, concat(Fname,' ' ,Lname) AS Name
FROM Employee
WHERE Salary > 1000;

--(6)
SELECT Fname,Lname AS Name
FROM Employee
WHERE Salary * 12 > 10000;

--(7)
SELECT Fname, Lname, Salary
FROM Employee
WHERE Sex = 'F';

--(8)
SELECT D.Dnum, D.Dname
FROM Departments AS D
WHERE D.MGRSSN = 968574;

--(9)
SELECT P.Pnumber, P.Pname, P.Plocation
FROM Project AS P
WHERE P.Dnum = 10;



----------------------------------------------------------------------------------------------------------------------------
--part 3
use ITI;

--(1)
SELECT DISTINCT Instructor.Ins_Name
FROM Instructor;

--(2)
SELECT Instructor.Ins_Name, Department.Dept_Name
FROM Instructor
LEFT JOIN Department ON Instructor.Dept_Id = Department.Dept_Id;

--(3)
SELECT concat(Student.St_Fname , ' ' , Student.St_Lname) AS Full_Name, Course.Crs_Name
FROM Student 
INNER JOIN Stud_Course ON Student.St_Id = Stud_Course.St_Id  
JOIN Course ON Course.Crs_Id = Stud_Course.Crs_Id
WHERE Stud_Course.Grade IS NOT NULL;


----------------------------------------------------------------------------------------------------------------------------
--part 4
use MyCompany;

--(1)
SELECT D.Dnum, D.Dname, E.SSN AS Manager_ID, CONCAT(E.Fname, ' ', E.Lname) AS Manager_Name
FROM Departments AS D
INNER JOIN Employee AS E ON D.MGRSSN = E.SSN;

--(2)
SELECT D.Dname, P.Pname
FROM Departments AS D
LEFT JOIN Project AS P ON D.Dnum = P.Dnum;

--(3)
SELECT D.Dependent_name, D.*, E.Fname, E.Lname
FROM Dependent AS D
INNER JOIN Employee AS E ON D.ESSN = E.SSN;

--(4)
SELECT Pnumber, Pname, Plocation
FROM Project
WHERE City IN ('Cairo', 'Alex');

--(5)
SELECT *
FROM Project
WHERE Pname LIKE 'a%';

--(6)
SELECT SSN, Fname, Lname, Salary
FROM Employee
WHERE Dno = 30 AND Salary BETWEEN 1000 AND 2000;

--(7)
SELECT E.Fname, E.Lname
FROM Employee AS E
INNER JOIN Works_for AS W ON E.SSN = W.ESSN
INNER JOIN Project AS P ON W.Pno = P.Pnumber
WHERE E.Dno = 10 AND P.Pname = 'AL Rabwah' AND W.Hours >= 10;

--(8)
SELECT E.Fname, E.Lname, P.Pname
FROM Employee AS E
INNER JOIN Works_for AS W ON E.SSN = W.ESSN
INNER JOIN Project AS P ON W.Pno = P.Pnumber
ORDER BY P.Pname;

--(9)
SELECT P.Pnumber, D.Dname, E.Lname, E.Address, E.Bdate
FROM Project AS P
INNER JOIN Departments AS D ON P.Dnum = D.Dnum
INNER JOIN Employee AS E ON D.MGRSSN = E.SSN
WHERE P.City = 'Cairo';
