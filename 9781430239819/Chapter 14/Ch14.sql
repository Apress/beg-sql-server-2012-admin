USE MASTER
GO
CREATE LOGIN BobLogin WITH PASSWORD='pass@word1'
GO
CREATE DATABASE UsedCars
GO
USE UsedCars
GO
CREATE USER Bob FOR LOGIN BobLogin
GO
CREATE SCHEMA Sales
AUTHORIZATION Bob
GO
CREATE SCHEMA Product
AUTHORIZATION Bob
GO
CREATE TABLE Product.Inventory
(car_id INT NOT NULL PRIMARY KEY,
car_make VARCHAR(50) NOT NULL,
car_model VARCHAR(50) NOT NULL,
car_year SMALLINT NOT NULL)
GO
CREATE TABLE Sales.Orders
(order_id INT NOT NULL PRIMARY KEY,
order_date DATETIME NOT NULL,
order_carsold INT REFERENCES Product.Inventory(car_id),
order_saleprice SMALLMONEY NOT NULL)
GO
INSERT INTO Product.Inventory VALUES (1,'Saab','9-3',1999),
(2,'Ford','Mustang',2003),(3,'Nissan','Pathfinder',2005)
GO

--Configuring Database Mirroring
BACKUP DATABASE UsedCars FROM DISK='c:\backup\dm\UsedCars.bak'

RESTORE DATABASE UsedCars FROM DISK='c:\backup\dm\UsedCars.bak' 
WITH MOVE 'UsedCars' TO 'C:\data\UsedCarsInst2.mdf',
MOVE 'UsedCars_log' TO 'C:\data\UsedCarsInst2.ldf',
NORECOVERY;

--Creating an Availability Group
USE MASTER
GO
CREATE DATBASE [DatabaseA]
GO
CREATE DATBASE [DatabaseB]
GO
CREATE DATABASE [DatabaseC]
GO

USE MASTER
GO
BACKUP DATABASE DatabaseA TO DISK='C:\backup\DatabaseA.bak'
GO
BACKUP DATABASE DatabaseB TO DISK='C:\backup\DatabaseB.bak'
GO
BACKUP DATABASE DatabaseC TO DISK='C:\backup\DatabaseC.bak'
GO
