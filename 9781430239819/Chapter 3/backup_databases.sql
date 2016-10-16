--Make a connection to SERVERONE using Windows Authentication
:CONNECT SERVERONE –E
--Issue a backup database command for ReportServer
BACKUP DATABASE [ReportServer] TO DISK='C:\backups\ReportServer.bak'
GO

--Make a connection to SERVERTWO using Windows Authentication
:CONNECT SERVERTWO –E
--Issue a backup database command for Products database
BACKUP DATABASE [Products] TO DISK='D:\SQLServer\Backups\Products.bak'
GO
