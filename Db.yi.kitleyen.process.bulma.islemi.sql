1. connect to the MASTER database of the server with the offending database
2. run the query below to find what transactions are open
3. kill any transaction that is blocking the SYSTEM SPIDS (1 to 50)

select * from master..sysprocesses where blocked <> 0
go
sp_who2 
go
-- find the blocked SPIDS, then check for open trans below, any value other than 0 means an open tran
SELECT distinct(open_tran) FROM master..SYSPROCESSES WHERE SPID=<suspect SPID>
-- now kill it!
kill <suspect SPID>

The database will go back to normal as soon as the kill ends. No service to restart, no boot required.

Read http://blog.sqlauthority.com/2007/04/25/sql-server-alternate-fix-error-1222-lock-request-time-out-period-exceeded/ and http://msdn.microsoft.com/en-us/library/aa337412.aspx for more info.