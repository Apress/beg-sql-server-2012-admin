USE [master]
GO
CREATE LOGIN [TestLogin] WITH PASSWORD=N'PaSsWoRd!'
 MUST_CHANGE, DEFAULT_DATABASE=[master],
CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO

USE [master]
GO
EXEC sys.sp_addsrvrolemember @loginame = N'TestLogin', @rolename = N'sysadmin'
GO

USE master
GO
GRANT SHUTDOWN TO <login>
GO

SELECT Name,Protocol_desc from sys.endpoints

CREATE LOGIN MyAppLogin WITH PASSWORD='PaSsWoRd1'
GO
DENY CONNECT on ENDPOINT::[TSQL Default TCP] to MyAppLogin
GO
DENY CONNECT on ENDPOINT::[TSQL Default VIA] to MyAppLogin
GO
DENY CONNECT on ENDPOINT::[TSQL Named Pipes] to MyAppLogin
GO

CREATE SERVER ROLE [DBA Role]

GRANT CONTROL SERVER TO [DBA Role]
GO
DENY ALTER ANY SERVER AUDIT TO [DBA Role]
GO
DENY ALTER ANY LOGIN TO [DBA Role]
GO
DENY IMPERSONATE ON LOGIN::CorporateAuditor TO [DBA Role]
GO
ALTER SERVER ROLE [DBA Role] ADD MEMBER [Julie]

USE master
GO
CREATE DATABASE Accounting
GO
CREATE LOGIN DevLogin WITH PASSWORD='asdif983*#@YRfjndsgfD'
GO
USE Accounting
GO
CREATE USER DevUser FOR LOGIN DevLogin
GO
GRANT CREATE TABLE TO DevUser
GO

USE Accounting
GO
CREATE TABLE Customers
(id INT NOT NULL,
firstname VARCHAR(20) NOT NULL,
lastname VARCHAR(40) NOT NULL)
GO

GRANT ALTER ON SCHEMA::dbo TO DevUser

CREATE SCHEMA People
GO
GRANT ALTER ON SCHEMA::People TO DevUser
GO

USE Accounting
GO
CREATE TABLE [People.Customers]
(id INT NOT NULL,
firstname VARCHAR(20) NOT NULL,
lastname VARCHAR(40) NOT NULL)
GO

CREATE USER DevUser FOR LOGIN DevLogin
WITH DEFAULT_SCHEMA = People

ALTER AUTHORIZATION ON SCHEMA::People TO TestUser

USE [Accounting]
GO
EXEC sp_addrolemember N'db_datareader', N'DevUser'
GO
GRANT SELECT ON Customers TO BusinessAnalysts

REVOKE SELECT ON Customers TO BusinessAnalysts

DENY SELECT ON Customers to Bob

USE AdventureWorks
GO
CREATE ROLE Developers AUTHORIZATION DevManager
GO

sp_addrolemember 'Developers', 'Bryan'

GRANT CREATE TABLE TO Developers

SELECT * FROM fn_my_permissions(NULL, 'DATABASE');

SELECT HAS_PERMS_BY_NAME('Customers', 'OBJECT', 'SELECT')

EXECUTE AS USER=’Bryan’
GO
SELECT HAS_PERMS_BY_NAME('Customers', 'OBJECT', 'SELECT')
GO

USE master
GO
CREATE DATABASE Customers
GO
Sp_configure 'show advanced options', 1
RECONFIGURE
GO
Sp_configure 'contained database authentication', 1
RECONFIGURE WITH OVERRIDE
GO

ALTER DATABASE Customers SET CONTAINMENT=PARTIAL;

USE Customers
GO
CREATE USER [SalesRep1] WITH PASSWORD='pass@word1';
GO

CREATE USER [ROB-DENALI-1\Bob] 

--
--Open a Command Shell in the context of the Windows User Bob
--You can do this without completely logging out of the desktop by using the RUNAS command
--You will need to be an administrator or have impersonation rights on Bob for this to work
--
--Click Start and type, RUNAS /USER:<usernanme> "CMD.EXE" 
--where <username> is Bob in this script or whatever the name of the local user you created.
--
--Once the command window is open you can try to connect to the SQL instance directly using
--SQLCMD -E -S. 
--
--and try to connect directly to the database
--SQLCMD -E -S. -d "Customers"


select * from sys.dm_db_uncontained_entities