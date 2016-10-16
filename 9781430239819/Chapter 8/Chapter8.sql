BACKUP DATABASE AdventureWorks2012
TO DISK = 'c:\data\AdventureWorks2012.bak';


EXEC sp_addumpdevice 
    @devtype = 'disk',
    @logicalname = 'MyBackupDevice',
    @physicalname = 'c:\data\AdventureWorks2008.bak';



BACKUP DATABASE AdventureWorks2012
TO MyBackupDevice;



DECLARE @BackupLocation NVARCHAR(100) ;
SET @BackupLocation = 'c:\data\AdventureWorks2012_'
    + CONVERT(NVARCHAR(8), GETDATE(), 112) + '.bak' ;
BACKUP DATABASE AdventureWorks2012
TO DISK = @BackupLocation
WITH INIT ;




DECLARE @BackupLocation NVARCHAR(100) ;
SET @BackupLocation = 'c:\data\AdventureWorks2012_'
    + CONVERT(NVARCHAR(8), GETDATE(), 112) + '.bak' ;
BACKUP DATABASE AdventureWorks2012
TO DISK = @BackupLocation
WITH INIT, CHECKSUM  ;



DECLARE @BackupLocation NVARCHAR(100) ;
SET @BackupLocation = 'c:\data\AdventureWorks2012_'
    + CONVERT(NVARCHAR(8), GETDATE(), 112) + '.bak' ;
BACKUP DATABASE AdventureWorks2012
TO DISK = @BackupLocation
WITH INIT,CHECKSUM, COMPRESSION, FORMAT ;



DECLARE @BackupLocation NVARCHAR(100);
SET @BackupLocation = 'c:\data\AdventureWorks2012_' +
CONVERT(NVARCHAR(8),GETDATE(),112) + '_diff.bak';
BACKUP DATABASE AdventureWorks2012
TO DISK = @BackupLocation
WITH INIT, CHECKSUM, DIFFERENTIAL;





SELECT  df.name
FROM    sys.database_files AS df;



ALTER DATABASE AdventureWorks2012
SET RECOVERY FULL ;





BACKUP DATABASE AdventureWorks2012
FILE = 'AdventureWorks2012_DATA'
TO DISK = 'c:\data\AdventureWorks2012_DATA.bak'
WITH INIT ;





BACKUP DATABASE AdventureWorks2012
FILEGROUP = 'Primary'
TO DISK = 'c:\data\AdventureWorks2012_Primary.bak'
WITH INIT;





BACKUP LOG AdventureWorks2012
TO DISK = 'c:\data\AdventureWorks2012_log.bak' ;





BACKUP DATABASE AdventureWorks2012
TO DISK = 'c:\data\AdventureWorks2012_Copy.bak'
WITH COPY_ONLY ;




--very simple query to back up user databases
DECLARE @backupscript NVARCHAR(MAX),
    @dbname NVARCHAR(100),
    @dbpath NVARCHAR(100) ;

DECLARE DBList CURSOR FAST_FORWARD
FOR
SELECT  name
FROM    sys.databases
WHERE   database_id BETWEEN 5 AND 32767
        AND state = 0 ;

OPEN DBList ;

FETCH NEXT FROM DBList INTO @dbname ;

WHILE @@FETCH_STATUS = 0 
    BEGIN
        SET @dbpath = 'C:\DATA' + @dbname + '_' + CONVERT(NVARCHAR, GETDATE(), 112)
            + '.bak'' WITH INIT' ;
        BACKUP DATABASE @dbname TO DISK = @dbpath WITH INIT, CHECKSUM ;
        FETCH NEXT FROM DBList INTO @dbname ;
    END

CLOSE DBList ;
DEALLOCATE DBList ;






USE master ;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Chapter8Backup' ;
GO
CREATE CERTIFICATE Chapter8Certificate WITH SUBJECT = 'Chapter 8 Certificate' ;
GO
USE EncryptionTest ;
GO
CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_128 ENCRYPTION BY SERVER
    CERTIFICATE Chapter8Certificate ;
GO
ALTER DATABASE EncryptionTest
SET ENCRYPTION ON ;




USE [master] ;
GO
BACKUP CERTIFICATE Chapter8Certificate TO FILE =
'c:\data\Chapter8Certificate'
WITH PRIVATE KEY (FILE = 'c:\data\pkChapter8Certificate',
ENCRYPTION BY PASSWORD = 'Chapter8Backup') ;





BACKUP DATABASE EncryptionTest
TO DISK = 'c:\data\EncryptionTest.bak' ;







EXEC sp_configure 
    'backup compression default',
    '1' ;
RECONFIGURE WITH OVERRIDE ;






BACKUP DATABASE AdventureWorks2012
TO DISK = 'c:\data\AdventureWorks2012_uncompressed.bak'
WITH INIT, NO_COMPRESSION ;






BACKUP DATABASE AdventureWorks2012
TO DISK = 'c:\data\AdventureWorks2012_compressed.bak'
WITH INIT, COMPRESSION ;








