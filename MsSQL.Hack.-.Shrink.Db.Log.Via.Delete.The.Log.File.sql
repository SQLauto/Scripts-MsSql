/*
	SHRINK DB LOG FILE WITH DELETING LOG FILE
	http://www.sqlhacks.com/Administration/Shrink-Log
*/
/*
How to shrink a log file with MSSQL
====================================
Log files can grow quite large. During an Accounting upgrade, the log file grew to 250Gb! And it did not shrink. The 'people' that wrote the accounting software decided to do the upgrade as a single transaction!
After the upgrade completed there is no need to keep the 250Gb transaction log.
Applies to:
Microsoft SQL Server 2000
Microsoft SQL Server 2005
Microsoft SQL Server 2008
*/

/*
Deleting the log
====================================
Get the filenames & location with SQL Server 2005 & SQL Server 2008
The log file usually has the _log at the end, unless you have given another name to the log file.
*/
USE sql911;
go
SELECT CAST(name AS VARCHAR(20)) AS 'Name',
       CAST(physical_name AS VARCHAR(75)) AS 'Filename'
FROM sys.database_files;
go

/*
Get the filenames & location with SQL Server 2000
====================================
The log file usually has the _log at the end, unless you have given another name to the log file.
USE sql911;
go
SELECT CAST(name AS VARCHAR(20)) AS 'Name',
       CAST(filename AS VARCHAR(75)) AS 'Filename'
FROM sysfiles
go
*/

/*
Detach the log
====================================
*/
USE master;
go
SP_DETACH_DB 'sql911';
go

/*
Nobody must be in the database to detach it.
or set the database to single user mode with:
ALTER DATABASE sql911
SET single_user WITH ROLLBACK IMMEDIATE;
go

-- There was no message from SQL Server for sp_detach_db.
*/

/*
Delete the log
====================================
Open CMD window from windows start menu/run

Microsoft Windows [Version 5.2.3790]
(C) Copyright 1985-2003 Microsoft Corp.

C:\Documents and Settings\froggy>del "C:\Program Files\Microsoft SQL Server\MSSQ
L.1\MSSQL\DATA\sql911_log.ldf"

C:\Documents and Settings\froggy>
*/

/*
Attach the database again
====================================
*/
USE master;
go
SP_ATTACH_DB 'sql911','C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\sql911.mdf';
go
/*
File activation failure. The physical file name "C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\sql911_log.ldf" may be incorrect.
New log file 'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\sql911_log.LDF' was created.
*/