:CONNECT $(myConnection)
BACKUP DATABASE $(myDatabase) TO DISK='C:\backups\$(myDatabase).bak'
