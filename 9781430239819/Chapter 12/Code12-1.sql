USE MASTER
GO
CREATE SERVER AUDIT [Compliance Audit]
TO FILE
(    FILEPATH = N'c:\audit'
)
WITH
(    QUEUE_DELAY = 1000,
     ON_FAILURE = CONTINUE
)
GO

USE master
GO
ALTER SERVER AUDIT [Compliance Audit]
WHERE server_principal_id <> 268
GO

SELECT * FROM sys.server_principals 

USE MASTER
GO
CREATE SERVER AUDIT SPECIFICATION [Logins]
FOR SERVER AUDIT [Compliance Audit]
ADD (FAILED_LOGIN_GROUP)
GO
ALTER SERVER AUDIT SPECIFICATION Logins WITH (STATE=ON)
GO
ALTER SERVER AUDIT [Compliance Audit] WITH (STATE=ON)
GO

select * from fn_get_audit_file('c:\audit\*.*',null,null)

USE [Accounting]
GO
CREATE DATABASE AUDIT SPECIFICATION [Customer information]
    FOR SERVER AUDIT [Compliance Audit]
        ADD(SELECT ON Customers by public)
GO

USE master
GO
CREATE DATABASE Accounting
GO
USE Accounting
GO
CREATE TABLE Customers
(id INT NOT NULL,
firstname VARCHAR(20) NOT NULL,
lastname VARCHAR(40) NOT NULL)
GO
ALTER DATABASE AUDIT SPECIFICATION [Customers Table]
    WITH (STATE=ON)
GO
CREATE PROCEDURE ViewCustomers
AS
BEGIN
SELECT * FROM Accounting.dbo.Customers
END
CREATE SERVER AUDIT [UserDefinedAudits]
TO FILE 
(	FILEPATH = N'C:\audit'
	,MAXSIZE = 0 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
)
WITH
(	QUEUE_DELAY = 1000
	,ON_FAILURE = CONTINUE
)
GO
ALTER SERVER AUDIT [UserDefinedAudits]
WITH (STATE=ON)
GO
USE [master]
GO
CREATE SERVER AUDIT SPECIFICATION [CustomAudits]
FOR SERVER AUDIT [UserDefinedAudits]
ADD (USER_DEFINED_AUDIT_GROUP)
WITH (STATE=ON)
GO
EXEC sp_audit_write @user_defined_event_id =  1000 , 
              @succeeded =  1
            , @user_defined_information = N'User Bob logged into application.' ;


USE [master]
GO
CREATE LOGIN BankManagerLogin WITH PASSWORD='g4mqw9K@32!@'
GO
CREATE DATABASE ContosoBank
GO
USE [ContosoBank]
GO
CREATE USER BankManagerUser FOR LOGIN BankManagerLogin
GO
CREATE TABLE Customers
(customer_id INT PRIMARY KEY,
first_name varchar(50) NOT NULL,
last_name varchar(50) NOT NULL,
social_security_number varbinary(100) NOT NULL)
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON Customers TO BankManagerUser
GO
CREATE SYMMETRIC KEY BankManager_User_Key
AUTHORIZATION BankManagerUser
WITH ALGORITHM=TRIPLE_DES
ENCRYPTION BY PASSWORD='HighFeesRule!'
GO
EXECUTE AS USER='BankManagerUser'
GO
OPEN SYMMETRIC KEY [BankManager_User_Key] DECRYPTION BY PASSWORD='HighFeesRule!'
GO
INSERT INTO Customers VALUES (1,'Howard','Stern',
EncryptByKey(Key_GUID('BankManager_User_Key'),'042-32-1324'))
INSERT INTO Customers VALUES (2,'Donald','Trump',
EncryptByKey(Key_GUID('BankManager_User_Key'),'035-13-6564'))
INSERT INTO Customers VALUES (3,'Bill','Gates',
EncryptByKey(Key_GUID('BankManager_User_Key'),'533-13-5784'))
GO

CLOSE ALL SYMMETRIC KEYS
GO
OPEN SYMMETRIC KEY [BankManager_User_Key] DECRYPTION BY PASSWORD='HighFeesRule!'
GO

SELECT customer_id,first_name + ' ' + last_name AS ‘Name’,
CONVERT(VARCHAR,DecryptByKey(social_security_number)) as 'Social Security Number'
FROM Customers
GO

CLOSE ALL SYMMETRIC KEYS
GO
REVERT
GO
USE [ContosoBank]
GO
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'Some!@Complex*@(39'
GO
CREATE CERTIFICATE BankManagersCert
AUTHORIZATION BankManagerUser
WITH SUBJECT=’Bank manager’’s certificate’
GO
OPEN SYMMETRIC KEY [BankManager_User_Key] DECRYPTION BY PASSWORD='HighFeesRule!'
GO
ALTER SYMMETRIC KEY BankManager_User_Key
ADD ENCRYPTION BY CERTIFICATE BankManagersCert
GO
ALTER SYMMETRIC KEY BankManager_User_Key
DROP ENCRYPTION BY PASSWORD='HighFeesRule!'
GO
CLOSE ALL SYMMETRIC KEYS
GO
EXECUTE AS USER='BankManagerUser'
GO
USE [ContosoBank]
GO
OPEN SYMMETRIC KEY [BankManager_User_Key] DECRYPTION BY CERTIFICATE BankManagersCert
GO
SELECT customer_id,first_name + ' ' + last_name,
CONVERT(VARCHAR,DecryptByKey(social_security_number)) as 'Social Security Number'
FROM Customers
GO
CLOSE ALL SYMMETRIC KEYS
GO
USE master;
GO
--This database master key is created in master
-- and is used to protect the certificate
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'EOhnDGS6!7JKv';
GO
--This certificate is used to protect the database encryption key
CREATE CERTIFICATE MyServerCert WITH SUBJECT = 'My DEK Certificate';
GO
--You are now ready to create the Database Encryption Key
USE ContosoBank
GO
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_128
ENCRYPTION BY SERVER CERTIFICATE MyServerCert
GO
ALTER DATABASE ContosoBank SET ENCRYPTION ON;
GO
