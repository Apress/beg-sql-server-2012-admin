--Detecting fragmentation
CREATE DATABASE Sales
GO
CREATE TABLE Customers (customer_id INT PRIMARY KEY,
customer_name CHAR(255) NOT NULL)
GO
INSERT INTO Customers VALUES(1,'user1')
GO
DECLARE @i INT
WHILE (@i<1000)
BEGIN
INSERT INTO Customers(customer_id,customer_name) VALUES(@i,'UserXXXX')

SET @i=@i+1
END
GO


DBCC SHOWCONTIG(‘Customers’)

--Distribution Statistics
CREATE TABLE LotsOfRandomNumbers
(number_generated INT,
seed INT,
random_number FLOAT)
GO

--Create sample data
DECLARE @i INT
DECLARE @RNF FLOAT
DECLARE @RNI INT
SET @i=0

WHILE (@i <= 100000)
BEGIN
SET @RNF = RAND(@i)
INSERT INTO LotsOfRandomNumbers VALUES((CAST(0x7FFFFFFF AS int) * @RNF),@i,@RNF )
SET @i=@i+1
END
GO
CREATE NONCLUSTERED INDEX NC_number_generated ON dbo.LotsOfRandomNumbers(number_generated)
GO

SELECT s.object_id, 
   OBJECT_NAME(s.object_id) AS table_name, 
   COL_NAME(s.object_id, sc.column_id) AS 'Column Name',
      s.Name AS 'Name of the statistics',
	  s.auto_created as 'Is automatically created'
FROM sys.stats AS s
 INNER JOIN sys.stats_columns AS sc
  ON s.stats_id = sc.stats_id AND s.object_id = sc.object_id 
WHERE s.object_id = OBJECT_ID( 'dbo.LotsOfRandomNumbers')
GO

SELECT seed FROM LotsOfRandomNumbers WHERE random_number < .5
GO
UPDATE STATISTICS dbo.LotsOfRandomNumbers
GO
UPDATE STATISTICS dbo.LotsOfRandomNumbers WITH SAMPLE 25 PERCENT, ALL
GO

