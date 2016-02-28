/*
Find Top 5 expensive Queries from a Read IO perspective
http://www.sqlservercentral.com/scripts/DMVs/102045/
*/

SELECT TOP 5 qt.text AS 'SQL', qstats.total_physical_reads AS 'Total Physical Reads',
 qstats.total_physical_reads/qstats.execution_count AS 'Average Physical Reads',
    qstats.execution_count AS 'Execution Count',
    qstats.total_worker_time/qstats.execution_count AS 'Average Worker Time',
    qstats.total_worker_time AS 'Total Worker Time',
    DATEDIFF(Hour, qstats.creation_time, GetDate()) AS 'AgeInCache In Hours', db_name(qt.dbid) AS 'Database Name'
    FROM sys.dm_exec_query_stats AS qstats
    CROSS APPLY sys.dm_exec_sql_text(qstats.sql_handle) AS qt
    WHERE qt.dbid = db_id() -- Filter by current database
    ORDER BY qstats.total_physical_reads DESC