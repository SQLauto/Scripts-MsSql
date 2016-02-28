/*
Shrink Database Log File
http://stackoverflow.com/questions/646845/sql-server-2008-log-will-not-truncate-driving-me-crazy/646891#646891
*/



USE TriVioCloudDB
GO
-- Truncate the Transaction log
ALTER DATABASE TriVioCloudDB SET RECOVERY SIMPLE
CHECKPOINT
--ALTER DATABASE TriVioCloudDB SET RECOVERY FULL
GO
-- Shrink the Transaction Log as recommended my Microsoft.
DBCC SHRINKFILE ('TriVioCloudDB_Log', 1)
GO
 -- Pass the freed pages back to OS control.
DBCC SHRINKDATABASE (TriVioCloudDB, TRUNCATEONLY)
GO
-- Tidy up the pages after shrink
DBCC UPDATEUSAGE (0);
GO
-- IF Required but not essential
-- Force to update all tables statistics
exec sp_updatestats
GO


/*
-- SIMPLE WAY 
Use YourDatabase
GO

DBCC sqlperf(logspace)  -- Get a "before" snapshot
GO  

BACKUP LOG BSDIV12Update WITH TRUNCATE_ONLY;  -- Truncate the log file, don't keep a backup
GO

DBCC SHRINKFILE(YourDataBaseFileName_log, 2);  -- Now re-shrink (use the LOG file name as found in Properties / Files.  Note that I didn't quote mine).
GO

DBCC sqlperf(logspace)  -- Get an "after" snapshot
GO

-- */