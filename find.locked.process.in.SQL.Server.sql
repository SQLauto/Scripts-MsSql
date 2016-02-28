/*
Use following commands to find out exactly what processes are holding the exclusive locks on your table. 
FYI, creation of any type index must put exclusive locks on a table due to the complexity of the task. 
In clustered indexes the data are re-arranged physically on the disk. 
No access will be available on the table unless you specify the option ONLINE = OFF at index creation.

Before running, REPLACE DATABASE_NAME, DB_ID, OBJ_ID and SPID with real integer values.
*/
CREATE TABLE tempdb..#temp_lock
(spid int, dbid int, ObjId int, IndId int, Type nvarchar(30), Resource nvarchar(100), Mode nvarchar(10), Status nvarchar(30))

Use DATABASE_NAME

GO

insert into tempdb..#temp_lock exec master..sp_lock

select spid, ObjId, mode, name from tempdb..#temp_lock as a inner join [test2]..sysobjects as b on a.ObjId= b.id where a.dbid = DB_ID
/*
Identify The Spid which is holding "X" mode locks on your table. Note down ObjId and SPID values from previous query.

Find out what the locking Spid is executing.
*/
dbcc inputbuffer (SPID)
/*
or more detailed:
*/
DECLARE @Handle binary(252)

SELECT @Handle = sql_handle FROM master..sysprocesses WHERE spid = SPID

SELECT * FROM ::fn_get_sql(@Handle) Go
/*
Decide whether to terminate the process or commit the transaction if you know who (user) is executing.
*/
KILL SPID
/*
Create the index again.
*/