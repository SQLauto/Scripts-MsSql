/*
Find Top 5 expensive Queries from a Write IO perspective
http://www.sqlservercentral.com/scripts/DMVs/102046/
*/
SELECT TOP 5 sqltxt.text AS 'SQL', qstats.total_logical_writes AS [Total Logical Writes],
qstats.total_logical_writes/DATEDIFF(second, qstats.creation_time, GetDate()) AS 'Logical Writes Per Second',
qstats.execution_count AS 'Execution Count',
qstats.total_worker_time AS [Total Worker Time],
qstats.total_worker_time/qstats.execution_count AS [Average Worker Time],
qstats.total_physical_reads AS [Total Physical Reads],
DATEDIFF(Hour, qstats.creation_time, GetDate()) AS 'TimeInCache in Hours',
qstats.total_physical_reads/qstats.execution_count AS 'Average Physical Reads',
db_name(sqltxt.dbid) AS DatabaseName
FROM sys.dm_exec_query_stats AS qstats
CROSS APPLY sys.dm_exec_sql_text(qstats.sql_handle) AS sqltxt
WHERE sqltxt.dbid = db_id()
ORDER BY qstats.total_logical_writes DESC