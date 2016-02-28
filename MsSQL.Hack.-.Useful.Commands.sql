-- ReCalculate Usage Statistics
DBCC UPDATEUSAGE (0);

-- Force to update all tables statistics
exec sp_updatestats
 
-- Show Open Transactions   
DBCC OPENTRAN;

-- Show Log Space Sizes
DBCC sqlperf(logspace);

-- Sql Server Monitoring #1
Exec Sp_Monitor;


-- Sql Server Monitoring #2
select @@CONNECTIONS as 'Connections', 
       @@CPU_BUSY as '% usage', 
       @@ERROR as 'Error', 
       @@IO_BUSY as 'I/O', 
       @@LANGUAGE as 'Language', 
       @@LOCK_TIMEOUT as 'Lock timeout', 
       @@MAX_CONNECTIONS as 'Max Connections', 
       @@MAX_PRECISION as 'Precision', 
       @@PACK_RECEIVED as 'Packet received', 
       @@PACK_SENT as 'Packets Sent', 
       @@PACKET_ERRORS as 'Packet Errors', 
       @@SERVERNAME as 'Server', 
       @@SERVICENAME as 'Services', 
       @@TOTAL_ERRORS as 'Errors', 
       @@TOTAL_READ as 'Reads', 
       @@TOTAL_WRITE as 'Writes', 
       @@VERSION as 'Version';


-- Monitor SQL Logs
DBCC SQLPERF(LOGSPACE) WITH no_infomsgs;

--Monitoring network activity 
DBCC sqlperf(netstats) WITH no_infomsgs;

