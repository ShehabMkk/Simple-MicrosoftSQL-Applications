CREATE DATABASE Route_Assignment
use Route_Assignment

CREATE TABLE Airline
(
    Airline_NAME VARCHAR(20) NOT NULL,
    AL_Id INT PRIMARY KEY NOT NULL,
    Airline_Address VARCHAR(50),
    CONT_Person int,
)

CREATE TABLE Aircraft
(
    AC_Id INT PRIMARY KEY NOT NULL,
    Capacity int,
    Model VARCHAR(20),
    Maj_pilot VARCHAR(20),
    Assitant VARCHAR(20),
    Host1 VARCHAR(20),
    Host2 VARCHAR(20),
    AL_Id INT REFERENCES Airline(AL_Id) NOT NULL,
)

CREATE TABLE Airline_PHONES 
(
    AL_Id INT REFERENCES Airline(AL_Id) NOT NULL,
    Phones int NOT NULL,
    PRIMARY KEY (AL_Id,Phones),
)

CREATE TABLE Transactions
(
    AL_Id INT REFERENCES Airline(AL_Id) NOT NULL,
    T_Id INT PRIMARY KEY NOT NULL,
    T_Description VARCHAR(50),
    Amount money,
    T_DATE DATE,
)

CREATE TABLE Employee
(
    AL_Id INT REFERENCES Airline(AL_Id) NOT NULL,
    E_Id INT PRIMARY KEY NOT NULL,
    E_NAME VARCHAR(20) NOT NULL,
    E_ADDRESS VARCHAR(50),
    GENDER CHAR,
    BDATE DATE,
    POSITION VARCHAR(20),
)

CREATE TABLE Employee_Qualifications 
(
    E_Id INT REFERENCES Employee(E_Id) NOT NULL,
    Qualifications VARCHAR(50) not null,
    PRIMARY KEY (E_Id,Qualifications),
)

CREATE TABLE Route
(
    R_Id INT PRIMARY KEY NOT NULL,
    distination VARCHAR(50) not null,
    distance int,
    origin VARCHAR(20),
    classification VARCHAR(50),
)

CREATE TABLE AC_Routes
(
    AC_Id INT REFERENCES Aircraft(AC_Id),
    R_Id INT REFERENCES Route(R_Id),
    Departure DATETIME NOT NULL,
    Price money,
    NUM_OF_PASS INT,
    ARRIVAL DATETIME NOT NULL,
    PRIMARY KEY(AC_Id,R_Id,Departure),
)

