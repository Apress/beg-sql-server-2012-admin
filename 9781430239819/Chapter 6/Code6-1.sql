USE [master]
GO

CREATE DATABASE [VetClinic]
GO

USE [master]
GO

ALTER DATABASE VetClinic
SET RECOVERY FULL
GO

USE [VetClinic]
GO

CREATE TABLE [Pets]
(pet_id         INT                       PRIMARY KEY,
pet_name    VARCHAR(50)    NOT NULL,
pet_weight  INT                       NULL)
GO

ALTER TABLE [Pets]
ADD [MicroChipID] VARCHAR(100) NOT NULL
CONSTRAINT [MicroChip_Unique] UNIQUE
GO

USE [VetClinic]
GO

INSERT INTO Pets
VALUES(1,'Zeus',185,'398BF49'),
(2,'Lady',155,'191ABBC'),
(3,'Deno',50,'790AG441'),
(4,'Rex',44,'CDD81322'),
(5,'Rover',15,'A8719841')
GO

CREATE TABLE [Owners]
(owner_id         INT                     PRIMARY KEY,
pet_id                INT                     REFERENCES Pets(pet_id),
owner_name    VARCHAR(50)   NOT NULL)
GO

INSERT INTO Owners VALUES(1,2,'Bryan'),
(2,3,'Rob'),
(3,1,'Rob')

CREATE TABLE MicroChips
(MicroChipID VARCHAR(100) UNIQUE)
GO

INSERT INTO MicroChips VALUES('34BA123')
GO
DECLARE @name VARCHAR(20)
SET @name='Rob'
SELECT DATALENGTH(@name)
GO

SELECT pet_name, pet_weight FROM Pets
GO
SELECT * FROM Pets
GO
SELECT TOP 3 * FROM Pets ORDER BY pet_weight ASC
GO
SELECT pet_name,owner_name FROM Pets
 INNER JOIN Owners
 ON Pets.pet_id=Owners.pet_id
GO
SELECT pet_name,owner_name FROM Pets
 LEFT OUTER JOIN Owners
 ON Pets.pet_id=Owners.pet_id
GO
INSERT INTO Pets
VALUES(6,'Roscoe',55,'F5CAA29'),
(7,'Missy',67,'B7C2A59'),
(8,'George',12,'AA63BC5'),
(9,'Spot',34,'CC8A674')

SELECT pet_name,pet_weight FROM Pets
    ORDER BY pet_weight DESC    
	OFFSET (0) ROWS    FETCH NEXT 3 ROWS ONLY;

	SELECT TOP 3 pet_name,pet_weight From Pets order by pet_weight DESC

	SELECT pet_name,pet_weight FROM Pets
    ORDER BY pet_weight DESC    
	OFFSET (3) ROWS    FETCH NEXT 3 ROWS ONLY;

INSERT INTO Pets (pet_id, pet_name, pet_weight, MicroChipID)
 VALUES (10,'Roxy',7,'1A8AF59'),
(11,'Champ',95,'81CB910'),
(12,'Penny',80,'C710A6B')


CREATE TABLE PetFood
(pet_food_id int IDENTITY(1,1),
 food_name varchar (20));

 INSERT INTO PetFood VALUES('Lamb and Rice'),('Chicken'),('Corn')

 SELECT * From PetFood

 CREATE SEQUENCE PetFoodIDSequence
     AS INT
	 START WITH 1
     INCREMENT BY 1

DROP TABLE PetFood
GO
CREATE TABLE PetFood
(pet_food_id int DEFAULT (NEXT VALUE FOR PetFoodIDSequence),
 food_name varchar (20));
GO

 INSERT INTO PetFood (food_name) VALUES('Lamb and Rice'),('Chicken'),('Corn')
 GO
 SELECT * from PetFood
 GO
BEGIN TRANSACTION
UPDATE Pets SET pet_name='Lady' WHERE pet_id=3
UPDATE Pets SET pet_name='Deno' WHERE pet_id=2
COMMIT
BEGIN TRANSACTION
DELETE FROM Pets
ROLLBACK
GO
BEGIN TRANSACTION
UPDATE Pets SET pet_name='Big Boy' WHERE pet_id=5
SELECT pet_name FROM Pets WHERE pet_id=5
GO
--User2 on a different connection issues
SELECT pet_name FROM Pets WHERE pet_id=5
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
GO
SELECT pet_name FROM Pets WHERE pet_id=5
GO
CREATE PROCEDURE GetID
@name VARCHAR(50)
AS
BEGIN
SELECT MicroChipID FROM Pets WHERE pet_name=@name
END
EXEC GetID 'Roxy'
GO
USE [VetClinic]
GO
/** Object:  StoredProcedure [dbo].[GetID]    Script Date: 04/29/2009 **/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetID]
@name VARCHAR(50)
AS
BEGIN
SELECT MicroChipID FROM Pets WHERE pet_name=@name
END
GO
CREATE FUNCTION GiantPets (@minWeight INTEGER)
RETURNS @retGiantPetsTable TABLE
(
pet_name     VARCHAR(50) NOT NULL,
pet_weight    INT                   NOT NULL,
owner_name VARCHAR(50) NOT NULL
)
AS
BEGIN
     INSERT @retGiantPetsTable
     SELECT p.pet_name, p.pet_weight,o.owner_name
     FROM Pets p, Owners o
     WHERE p.pet_id=o.pet_id AND p.pet_weight > @minWeight

     RETURN
END
GO
SELECT * FROM GiantPets(50)
GO
USE [VetClinic]
GO
CREATE TRIGGER ValidateMicroChip
ON Pets
FOR INSERT
AS

IF EXISTS(
SELECT MicroChipID FROM MicroChips
WHERE MicroChipID IN (
SELECT MicroChipID FROM inserted)
)

RAISERROR ('The chip was found!', 16, 1)
ELSE

BEGIN
     RAISERROR ('The chip was NOT found!', 16, 1)
     ROLLBACK
END

GO
INSERT INTO Pets VALUES (8,'Sushi',5,'0034DDA')
GO


