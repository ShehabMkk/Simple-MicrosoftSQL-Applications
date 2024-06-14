use Library;


-- Query Solutions:

--1. Full name of an employee with more than 3 letters in the First Name:
   SELECT CONCAT(Fname, ' ', Lname) AS FullName
   FROM Employee
   WHERE LEN(Fname) > 3;

--2. Total number of Programming books available in the library:
   SELECT COUNT(*) AS "NO OF PROGRAMMING BOOKS"
   FROM Book B
   JOIN Category C ON B.Cat_id = C.Id
   WHERE C.Cat_name = 'Programming';

--3. Number of books published by HarperCollins:
   SELECT COUNT(*) AS "NO_OF_BOOKS"
   FROM Book B
   JOIN Publisher P ON B.Publisher_id = P.Id
   WHERE P.Name = 'HarperCollins';

--4. User SSN and name, date of borrowing and due date of the User whose due date is before July 2022:
   SELECT U.SSN, U.User_Name, B.Borrow_date, B.Due_date
   FROM Users U
   JOIN Borrowing B ON U.SSN = B.User_ssn
   WHERE B.Due_date < '2022-07-01';

--5. Book title and author name in the specified format:
   SELECT CONCAT(B.Title, ' is written by ', A.Name) AS "Book Details"
   FROM Book B
   JOIN Book_Author BA ON B.Id = BA.Book_id
   JOIN Author A ON BA.Author_id = A.Id;

--6. Names of users who have letter 'A' in their names:
   SELECT User_Name
   FROM Users
   WHERE User_Name LIKE '%A%';

--7. User SSN who makes the most borrowing:
   SELECT TOP 1 User_ssn
   FROM Borrowing
   GROUP BY User_ssn
   ORDER BY COUNT(*) DESC;

--8. Total amount of money that each user paid for borrowing books:
   SELECT U.User_Name, SUM(B.Amount) AS "Total Paid"
   FROM Users U
   JOIN Borrowing B ON U.SSN = B.User_ssn
   GROUP BY U.User_Name;

--9. Category with the book that has the minimum amount of money for borrowing:
   SELECT C.Cat_name
   FROM Category C
   JOIN Book B ON C.Id = B.Cat_id
   JOIN Borrowing BO ON B.Id = BO.Book_id
   WHERE BO.Amount = (SELECT MIN(Amount) FROM Borrowing);

--10. Email of an employee if not found display address, if not found display date of birth:
   SELECT COALESCE(Email, Address, CONVERT(VARCHAR(10), DOB, 120)) AS Contact_Info
   FROM Employee;


--11. Category and number of books in each category:
    SELECT C.Cat_name, COUNT(B.Id) AS "Count Of Books"
    FROM Category C
    JOIN Book B ON C.Id = B.Cat_id
    GROUP BY C.Cat_name;

--12. Books not found in floor number 1 and shelf-code A1:
    SELECT B.Id
    FROM Book B
    WHERE B.Shelf_code NOT IN (
      SELECT S.Code
      FROM Shelf S
      WHERE S.Floor_num = 1 AND S.Code = 'A1'
    );

--13. Floor number, number of blocks, and number of employees working on that floor:
    SELECT F.Number AS Floor_Number, F.Num_blocks, COUNT(E.Id) AS Number_of_Employees
    FROM Floor F
    JOIN Employee E ON F.Number = E.Floor_no
    GROUP BY F.Number, F.Num_blocks;

--14. Book Title and User Name for borrowings between '3/1/2022' and '10/1/2022':
    SELECT B.Title, U.User_Name
    FROM Borrowing BR
    JOIN Book B ON BR.Book_id = B.Id
    JOIN Users U ON BR.User_ssn = U.SSN
    WHERE BR.Borrow_date BETWEEN '2022-03-01' AND '2022-10-01';

--15. Employee Full Name and Name of his/her Supervisor:
    SELECT CONCAT(E1.Fname, ' ', E1.Lname) AS Employee_FullName,
           CONCAT(E2.Fname, ' ', E2.Lname) AS Supervisor_Name
    FROM Employee E1
    JOIN Employee E2 ON E1.Super_id = E2.Id;

--16. Employee name and his/her salary, or bonus if no salary:
    SELECT Fname, Lname, COALESCE(Salary, Bouns) AS Salary_or_Bonus
    FROM Employee;

--17. Maximum and minimum salary for employees:
    SELECT MAX(Salary) AS Max_Salary, MIN(Salary) AS Min_Salary
    FROM Employee;


-- Functions and Procedures:

--18. Function to check if a number is even or odd:
    CREATE FUNCTION CheckEvenOrOdd (@Number INT)
    RETURNS VARCHAR(10)
    AS
    BEGIN
        RETURN (CASE WHEN @Number % 2 = 0 THEN 'Even' ELSE 'Odd' END);
    END;

--19. Function to display titles of books in a given category:
    CREATE FUNCTION GetBooksByCategory (@CategoryName VARCHAR(255))
    RETURNS TABLE
    AS
    RETURN (
        SELECT B.Title
        FROM Book B
        JOIN Category C ON B.Cat_id = C.Id
        WHERE C.Cat_name = @CategoryName
    );

--20. Function to display Book Title, user-name, amount of money, and due-date by user's phone:
    CREATE FUNCTION GetBorrowingDetailsByPhone (@Phone VARCHAR(255))
    RETURNS TABLE
    AS
    RETURN (
        SELECT B.Title, U.User_Name, BR.Amount, BR.Due_date
        FROM Borrowing BR
        JOIN Book B ON BR.Book_id = B.Id
        JOIN Users U ON BR.User_ssn = U.SSN
        JOIN User_phones UP ON U.SSN = UP.User_ssn
        WHERE UP.Phone_num = @Phone
    );

--21. Function to check if a user name is duplicated:
    CREATE FUNCTION CheckUserName (@UserName VARCHAR(255))
    RETURNS VARCHAR(255)
    AS
    BEGIN
        DECLARE @Count INT;
        DECLARE @Result VARCHAR(255);

        SELECT @Count = COUNT(*)
        FROM Users
        WHERE User_Name = @UserName;

        IF @Count > 1
            SET @Result = CONCAT(@UserName, ' is Repeated ', @Count, ' times');
        ELSE IF @Count = 1
            SET @Result = CONCAT(@UserName, ' is not duplicated');
        ELSE
            SET @Result = CONCAT(@UserName, ' is Not Found');

        RETURN @Result;
    END;


--22. Scalar function to return date in the specified format:
    CREATE FUNCTION FormatDate (@Date DATETIME, @Format VARCHAR(255))
    RETURNS VARCHAR(255)
    AS
    BEGIN
        RETURN FORMAT(@Date, @Format);
    END;

--23. Stored procedure to show the number of books per category:
    CREATE PROCEDURE GetBooksPerCategory
    AS
    BEGIN
        SELECT C.Cat_name, COUNT(B.Id) AS "Number of Books"
        FROM Category C
        JOIN Book B ON C.Id = B.Cat_id
        GROUP BY C.Cat_name;
    END;

--24. Stored procedure for updating manager information:
    CREATE PROCEDURE UpdateFloorManager (
        @OldEmpId INT, 
        @NewEmpId INT, 
        @FloorNum INT
    )
    AS
    BEGIN
        UPDATE Floor
        SET MG_ID = @NewEmpId
        WHERE Number = @FloorNum AND MG_ID = @OldEmpId;
    END;

-- Views:

--25. View AlexAndCairoEmp for employees living in Alex or Cairo:
    CREATE VIEW AlexAndCairoEmp AS
    SELECT *
    FROM Employee
    WHERE Address LIKE '%Alex%' OR Address LIKE '%Cairo%';

--26. View V2 that displays the number of books per shelf:
    CREATE VIEW V2 AS
    SELECT S.Code, COUNT(B.Id) AS "Number of Books"
    FROM Shelf S
    JOIN Book B ON S.Code = B.Shelf_code
    GROUP BY S.Code;

--27. View V3 that displays the shelf code with the maximum number of books using V2:
    CREATE VIEW V3 AS
    SELECT TOP 1 Code, "Number of Books"
    FROM V2
    ORDER BY "Number of Books" DESC;

-- Triggers and Table Creation:

--28. Table for ReturnedBooks and trigger for fees:
    CREATE TABLE ReturnedBooks (
        User_SSN VARCHAR(255),
        Book_Id INT,
        Due_Date DATE,
        Return_Date DATE,
        Fees DECIMAL(10, 2)
    );

    CREATE TRIGGER trgCheckReturnDate
    ON ReturnedBooks
    INSTEAD OF INSERT
    AS
    BEGIN
        DECLARE @DueDate DATE, @ReturnDate DATE, @Amount DECIMAL(10, 2), @UserSSN VARCHAR(255), @BookId INT;

        SELECT @UserSSN = i.User_SSN, @BookId = i.Book_Id, @DueDate = i.Due_Date, @ReturnDate = i.Return_Date
        FROM Inserted i;

        SELECT @Amount = Amount
        FROM Borrowing
        WHERE User_ssn = @UserSSN AND Book_id = @BookId;

        IF @ReturnDate > @DueDate
        BEGIN
            INSERT INTO ReturnedBooks (User_SSN, Book_Id, Due_Date, Return_Date, Fees)
            VALUES (@UserSSN, @BookId, @DueDate, @ReturnDate, @Amount * 0.2);
        END
        ELSE
        BEGIN
            INSERT INTO ReturnedBooks (User_SSN, Book_Id, Due_Date, Return_Date, Fees)
            VALUES (@UserSSN, @BookId, @DueDate, @ReturnDate, 0);
        END
    END;

--29. Insert new floor and manage employee positions:
    INSERT INTO Floor (Number, Num_blocks, MG_ID, Hiring_Date)
    VALUES (10, 2, 20, GETDATE());

    UPDATE Floor
    SET MG_ID = 12
    WHERE Number = (SELECT Number FROM Floor WHERE MG_ID = 5);

    UPDATE Floor
    SET MG_ID = 5
    WHERE Number = 6;

--30. View v_2006_check to display Manager id, Floor Number, Number of Blocks, and Hiring Date:
    CREATE VIEW v_2006_check AS
    SELECT MG_ID, Number AS Floor_Number, Num_blocks, Hiring_Date
    FROM Floor
    WHERE Hiring_Date BETWEEN '2022-03-01' AND '2022-05-31';

    -- Attempt to insert the data
    INSERT INTO v_2006_check (MG_ID, Floor_Number, Num_blocks, Hiring_Date)
    VALUES (2, 6, 2, '2023-07-08'); -- This will fail due to date not in the specified range and the floor no 6 already exist

    INSERT INTO v_2006_check (MG_ID, Floor_Number, Num_blocks, Hiring_Date)
    VALUES (4, 7, 1, '2022-04-08'); -- This will succeed as it meets the criteria

-- Triggers and Referential Integrity:

--31. Trigger to prevent modifications, deletions, or insertions in the Employee table:
    CREATE TRIGGER trgPreventModifications
    ON Employee
    FOR INSERT, UPDATE, DELETE
    AS
    BEGIN
        RAISERROR ('Modifications are not allowed on the Employee table.', 16, 1);
        ROLLBACK TRANSACTION;
    END;

--32. Testing Referential Integrity:

  --  A. Add a new User Phone Number with User_SSN = 50:
        INSERT INTO User_phones (User_ssn, Phone_num)
        VALUES (50, '123-456-7890');
        -- User_SSN = 50 does not exist in Users, it will fail due to foreign key constraint.

  --  B. Modify the employee id 20 in the employee table to 21:
        UPDATE Employee
        SET Id = 21
        WHERE Id = 20;
        -- there are dependent records in other tables like FLoor table, it will fail due to foreign key constraint.

  --  C. Delete the employee with id 1:
        DELETE FROM Employee
        WHERE Id = 1;
        -- there are dependent records in other tables like FLoor table, it will fail due to foreign key constraint.

  --  D. Delete the employee with id 12:
        DELETE FROM Employee
        WHERE Id = 12;
        -- there are dependent records in other tables like FLoor table, it will fail due to foreign key constraint.

  --  E. Create an index on the Salary column in the Employee table:
        CREATE CLUSTERED INDEX idx_Employee_Salary
        ON Employee (Salary);
        --there is already another clustered, Cannot create more than one clustered index on table 'Employee'.

