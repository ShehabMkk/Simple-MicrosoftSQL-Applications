--===========================================================================================================================--
--====================================================== part 1 =============================================================--
--===========================================================================================================================--

use ITI;

--1. Display instructors with salaries less than the average salary:
SELECT *
FROM instructor
WHERE salary < (SELECT AVG(salary) FROM instructor);

--2. Display department name with the instructor receiving the minimum salary:
SELECT d.dept_name
FROM instructor i
INNER JOIN department d ON i.dept_id = d.dept_id
WHERE i.salary = (SELECT MIN(salary) FROM instructor);

--3. Select the maximum two salaries in the instructor table:
SELECT TOP 2 salary
FROM instructor
ORDER BY salary DESC;

--4. Select the highest two salaries per department (using RANK):
SELECT ri.Ins_Name, ri.salary, d.dept_name
FROM (
    SELECT i.*, DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rnk
    FROM instructor i
) AS ri
INNER JOIN department d ON ri.dept_id = d.dept_id
WHERE ri.rnk <= 2;

--5. Select a random student from each department (using SAMPLE):
SELECT St_Id,St_Fname,Dept_Id
FROM (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY Dept_Id ORDER BY RAND()) AS r
  FROM Student
) AS rs
WHERE r = 1 and Dept_Id is not NULL;


--================================================================================--

USE MyCompany;

--1. Department with smallest employee ID:
SELECT D.Dname, D.Dnum
FROM Departments D
INNER JOIN Employee E ON D.Dnum = E.Dno
WHERE E.SSN = (
  SELECT MIN(SSN)
  FROM Employee
);

--2. Last name of managers with no dependents:
SELECT E.Lname
FROM Employee E
LEFT JOIN Dependent D ON E.SSN = D.ESSN
WHERE E.SSN IS NULL AND D.ESSN IS NULL;

--3. Departments with average salary below overall average:
SELECT D.Dnum, D.Dname, COUNT(*) AS NumEmployees
FROM Departments D
INNER JOIN Employee E ON D.Dnum = E.Dno
GROUP BY D.Dnum, D.Dname
HAVING AVG(E.Salary) < (
  SELECT AVG(Salary)
  FROM Employee
);

--4. Max 2 salaries:
SELECT TOP 2 SSN, CONCAT(Fname , ' ' , Lname) AS FullName, Salary
FROM Employee
ORDER BY Salary DESC;

--5. Employees with at least one dependent:
SELECT E.SSN, CONCAT(E.Fname , ' ' , E.Lname)AS FullName
FROM Employee AS E
WHERE EXISTS (
  SELECT *
  FROM Dependent D
  WHERE D.ESSN = E.SSN
);


--=========================================================================================================--

--===========================================================================================================================--
--====================================================== part 2 =============================================================--
--===========================================================================================================================--

use AdventureWorks2012;

--1. Sales Orders by Date Range:
SELECT SalesOrderID, ShipDate
FROM Sales.SalesOrderHeader
WHERE ShipDate >= '2002-07-28' AND ShipDate < '2014-07-30';

--2. Products with Low Standard Cost:
SELECT ProductID, Name
FROM Production.Product
WHERE StandardCost < 110.00;

--3. Products with Unknown Weight:
SELECT ProductID, Name
FROM Production.Product
WHERE Weight IS NULL;

--4. Products with Specific Colors:
SELECT ProductID, Name
FROM Production.Product
WHERE Color IN ('Silver', 'Black', 'Red');

--5. Products with Names Starting with "B":
SELECT ProductID, Name
FROM Production.Product
WHERE Name LIKE 'B%';

--6. Update Product Description and Find Descriptions with Underscore:
-- Update Description
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3;

-- Find Descriptions with Underscore
SELECT *
FROM Production.ProductDescription
WHERE Description LIKE '%_%';

--7. Unique Employee Hire Dates:
SELECT DISTINCT HireDate
FROM HumanResources.Employee;

--8. Products with List Price between 100 and 120:
SELECT CONCAT('The ', Name, ' is only! $', ListPrice) AS ProductInfo
FROM Production.Product
WHERE ListPrice >= 100.00 AND ListPrice < 120.00
ORDER BY ListPrice;
