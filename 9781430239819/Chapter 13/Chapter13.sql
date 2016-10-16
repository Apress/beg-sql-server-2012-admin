SELECT  *
FROM    sys.dm_os_performance_counters ;



SELECT  *
FROM    sys.dm_os_performance_counters AS dopc
WHERE   dopc.counter_name = 'Batch Requests/sec' ;







SELECT  p.[Name],
        soh.OrderDate,
        soh.AccountNumber,
        sod.OrderQty,
        sod.UnitPrice
FROM    Sales.SalesOrderHeader AS soh
JOIN    Sales.SalesOrderDetail AS sod
        ON soh.SalesOrderID = sod.SalesOrderID
JOIN    Production.Product AS p
        ON sod.ProductID = p.ProductID
WHERE   p.[Name] LIKE 'LL%'
        AND soh.OrderDate BETWEEN '1/1/2008' AND '1/6/2008' ;







SELECT  p.[Name],
        soh.OrderDate,
        soh.AccountNumber,
        sod.OrderQty,
        sod.UnitPrice
FROM    Sales.SalesOrderHeader AS soh
JOIN    Sales.SalesOrderDetail AS sod
        ON soh.SalesOrderID = sod.SalesOrderID
JOIN    Production.Product AS p
        ON sod.ProductID = p.ProductID
WHERE   p.[Name] LIKE 'LL%'
        AND soh.OrderDate BETWEEN '1/1/2008' AND '1/6/2008' ;







CREATE FUNCTION GovernorClassifier ()
RETURNS SYSNAME
    WITH SCHEMABINDING
AS 
BEGIN
    DECLARE @GroupName AS SYSNAME ;
    IF (APP_NAME() LIKE '%MANAGEMENT STUDIO%') 
        SET @GroupName = 'MyWorkLoad' ;
    RETURN @GroupName ;
END
GO




CREATE TABLE dbo.MyTable
    (Col1 INT NOT NULL,
     Col2 NVARCHAR(50) NULL
    )
    WITH (
         DATA_COMPRESSION = PAGE) ;






CREATE NONCLUSTERED INDEX ix_MyTable1
ON dbo.MyTable (Col2)
WITH ( DATA_COMPRESSION = ROW ) ;




SELECT OBJECT_ID()

SELECT 30.0/(-2.0)/2.0
SELECT 30.0 / -2.0 / 2.0

