BACKUP DATABASE RestoreTest
TO DISK = 'c:\data\RestoreTest.bak' ;



USE RestoreTest ;
CREATE TABLE dbo.Table1 (Id INT, Val NVARCHAR(50)) ;




RESTORE DATABASE RestoreTest
FROM DISK = 'c:\data\restoretest.bak'
WITH REPLACE ;





RESTORE DATABASE WholeNewRestore
FROM DISK = 'c:\data\restoretest.bak' ;







RESTORE DATABASE WholeNewRestore
FROM DISK = 'c:\data\restoretest.bak'
WITH MOVE 'RestoreTest' TO 'C:\Program Files\Microsoft SQL Server\MSSQL11.RANDORI\MSSQL\DATA\WholeNewRestore.mdf'
,MOVE 'RestoreTest_Log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL11.RANDORI\MSSQL\DATA\WholeNewRestore_Log.ldf' ;





RESTORE FILELISTONLY
FROM DISK = 'c:\data\restoretest.bak';







RESTORE HEADERONLY
FROM DISK = 'c:\data\restoretest.bak';






USE MASTER;
DROP DATABASE WholeNewRestore;
DROP DATABASE RestoreTest;




USE DiffTest ;
CREATE TABLE dbo.DataChanges
    (DataChangesId INT IDENTITY(1, 1)
                       NOT NULL,
     DataValue NVARCHAR(50) NOT NULL,
     UpdateDate DATETIME NOT NULL,
     CONSTRAINT PK_DataChanges PRIMARY KEY CLUSTERED (DataChangesId)
    ) ;

INSERT  INTO dbo.DataChanges
        (DataValue, UpdateDate)
VALUES  (N'First Row', GETDATE()),
        (N'Second Row', GETDATE()),
        (N'Third Row', GETDATE()) ;

BACKUP DATABASE DiffTest TO DISK = 'c:\data\difftest.bak' ;

INSERT  INTO dbo.DataChanges
        (DataValue, UpdateDate)
VALUES  (N'Fourth Row', GETDATE()),
        (N'Fifth Row', GETDATE()) ;

BACKUP DATABASE DiffTest
TO DISK = 'c:\data\difftest_diff.bak'
WITH DIFFERENTIAL ;

DELETE  dbo.DataChanges
WHERE   DataChangesId = 3 ;





RESTORE DATABASE DiffTest
FROM DISK = 'c:\data\difftest.bak'
WITH REPLACE, NORECOVERY ;







RESTORE DATABASE DiffTest
FROM DISK = 'c:\data\difftest_diff.bak';





USE master ;
DROP DATABASE DiffTest ;




CREATE DATABASE LogTest ;
GO
ALTER DATABASE LogTest SET RECOVERY FULL ;
GO

USE LogTest ;

CREATE TABLE BusinessData
    (BusinessDataId INT NOT NULL
                        IDENTITY(1, 1),
     BusinessValue NVARCHAR(50),
     UpdateDate DATETIME,
     CONSTRAINT pk_BusinessData PRIMARY KEY CLUSTERED (BusinessDataID)
    ) ;

INSERT  INTO BusinessData
        (BusinessValue, UpdateDate)
VALUES  ('Row 1', GETDATE()),
        ('Row 2', GETDATE()) ;

--Full backup
BACKUP DATABASE LogTest
TO DISK = 'c:\data\logtest.bak'

--create more business data
INSERT  INTO BusinessData
        (BusinessValue, UpdateDate)
VALUES  ('Row 3', GETDATE()),
        ('Row 4', GETDATE()) ;

--First Log Backup
BACKUP LOG LogTest
TO DISK = 'c:\data\logtest_log1.bak' ;

INSERT  INTO BusinessData
        (BusinessValue, UpdateDate)
VALUES  ('Row 5', GETDATE()),
        ('Row 6', GETDATE()) ;

--Second Log Backup
BACKUP LOG LogTest
TO DISK = 'c:\data\logtest_log2.bak' ;


INSERT  INTO BusinessData
        (BusinessValue, UpdateDate)
VALUES  ('Row 7', GETDATE()),
        ('Row 8', GETDATE()) ;
SELECT GETDATE();

--pause for two minutes
WAITFOR DELAY '00:02' ;

DELETE  BusinessData ;

--Final Log Backup, after the "accident"
BACKUP LOG LogTest
TO DISK = 'c:\data\logtest_log3.bak' ;
 GO
 USE master;






RESTORE DATABASE LogTest
FROM DISK = 'c:\data\logtest.bak'
WITH REPLACE, NORECOVERY ;







RESTORE LOG LogTest
FROM DISK = 'c:\data\logtest_log1.bak'
WITH NORECOVERY;

RESTORE LOG LogTest
FROM DISK = 'c:\data\logtest_log2.bak'
WITH NORECOVERY;

RESTORE LOG LogTest
FROM DISK = 'c:\data\logtest_log3.bak'
WITH STOPAT = 'Nov  25 2011  17:49:30';








SELECT * FROM dbo.BusinessData AS bd;





USE MASTER;
DROP DATABASE LogTest;








CREATE DATABASE FileTest ;

ALTER DATABASE FileTest
ADD FILEGROUP FILETESTFG ;

ALTER DATABASE FileTest
ADD FILE (
NAME = FileTest2,
FILENAME = 'c:\data\filetest2.ndf',
SIZE = 5MB,
MAXSIZE = 100MB,
FILEGROWTH = 5MB
) TO FILEGROUP FileTestFG ;
GO

USE FileTest ;

CREATE TABLE dbo.ft1
    (ID INT IDENTITY(1, 1)
            NOT NULL,
     Val NVARCHAR(50) NOT NULL
    )
ON  FileTestFG ;

INSERT  INTO dbo.ft1
        (Val)
VALUES  (N'Test') ;

BACKUP DATABASE FileTest
FILEGROUP = 'FileTestFG'
TO DISK = 'c:\data\FileTest_FileTestFG.bak'
WITH INIT ;

BACKUP LOG FileTest
TO DISK = 'c:\data\FileTest_Log.bak'
WITH INIT ;






RESTORE DATABASE FileTest
FILEGROUP = 'FileTestFG'
FROM DISK = 'c:\data\FileTest_FileTestFG.bak'
WITH NORECOVERY ;

RESTORE LOG FileTest
FROM DISK = 'c:\data\FileTest_Log.bak'
WITH RECOVERY ;







RESTORE VERIFYONLY FROM DISK = 'somepath'









