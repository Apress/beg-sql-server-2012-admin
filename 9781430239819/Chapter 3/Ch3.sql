--If you created the BankOfFees database using SSMS you don't have to issue the CREATE DATABASE statement again
USE MASTER
GO
CREATE DATABASE BankOfFees
GO


USE BankOfFees
GO
CREATE TABLE Customers
(customer_id INT NOT NULL,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL)
GO
INSERT INTO Customers
VALUES (1,'Barack','Obama'),
VALUES (2,'George','Bush'),
VALUES (3,'Bill','Clinton')
GO
SELECT * FROM Customers
GO

--The JobReports table is used in the PowerShell provider part of the chapter 
USE MASTER
GO
CREATE TABLE JobReports
(job_engine CHAR(6),
job_engine_id VARCHAR(50),
job_name VARCHAR(255),
job_last_outcome VARCHAR(50),
report_time datetime DEFAULT GETDATE())
GO