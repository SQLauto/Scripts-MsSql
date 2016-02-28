/*If you know about SP_WHO2 (undocumented) (DBA savior) statement 
from SQL Server 7/2000 days you need no introduction to find what 
SPID is blocking  and which is getting blocked.

Here is another incident that caused much of chaos on a SQL instance 
that has been upgraded from SQL 7 to 2000 and then to 2008 directly! 
All is well until 2 weeks on newly married 2008 platform and trouble 
started when the batch process has been executed for first time on 
this new instance. This has escalated as a serious blocking issue 
on the production instance having turned trace-flags 1222 & 3605 ON 
to find if there are further deadlock situation. I will cover the root 
cause of the statements that are causing blocking/locking/deadlocking 
(what not!) in another blog post, but at this point of time here are 
quick TSQL I have executed on that instance to get the snapshot of 
what is happening.

Source: Technet & MS PSS

See the top 100 statements that are executing with CPU time & reads:
*/
SELECT  TOP 100
            [Object_Name] = object_name(st.objectid),
            creation_time, 
            last_execution_time, 
            total_cpu_time = total_worker_time / 1000, 
            avg_cpu_time = (total_worker_time / execution_count) / 1000,
            min_cpu_time = min_worker_time / 1000,
            max_cpu_time = max_worker_time / 1000,
            last_cpu_time = last_worker_time / 1000,
            total_time_elapsed = total_elapsed_time / 1000 , 
            avg_time_elapsed = (total_elapsed_time / execution_count) / 1000, 
            min_time_elapsed = min_elapsed_time / 1000, 
            max_time_elapsed = max_elapsed_time / 1000, 
            avg_physical_reads = total_physical_reads / execution_count,
            avg_logical_reads = total_logical_reads / execution_count,
            execution_count, 
            SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
                  (
                        (
                              CASE statement_end_offset
                                    WHEN -1 THEN DATALENGTH(st.text)
                                    ELSE qs.statement_end_offset
                              END 
                              - qs.statement_start_offset
                        ) /2
                  ) + 1
            ) as statement_text
FROM 
            sys.dm_exec_query_stats qs
CROSS APPLY 
            sys.dm_exec_sql_text(qs.sql_handle) st
WHERE
            Object_Name(st.objectid) IS NOT NULL
            AND st.dbid = DB_ID()
ORDER BY 
            db_name(st.dbid), 
            total_worker_time / execution_count  DESC 

/*
Further to the above statement the following TSQL has been executed to get what-is-blocking, 
which will be a thread-to-needle to solve the issue:
*/

SELECT 
--#A
Blocking.session_id as BlockingSessionId
, Sess.login_name AS BlockingUser 
, BlockingSQL.text AS BlockingSQL
, Waits.wait_type WhyBlocked
--#B
, Blocked.session_id AS BlockedSessionId
, USER_NAME(Blocked.user_id) AS BlockedUser
, BlockedSQL.text AS BlockedSQL
, DB_NAME(Blocked.database_id) AS DatabaseName
FROM sys.dm_exec_connections AS Blocking
INNER JOIN sys.dm_exec_requests AS Blocked 
ON Blocking.session_id = Blocked.blocking_session_id
INNER JOIN sys.dm_os_waiting_tasks AS Waits 
ON Blocked.session_id = Waits.session_id
RIGHT OUTER JOIN sys.dm_exec_sessions Sess 
ON Blocking.session_id = sess.session_id  
CROSS APPLY sys.dm_exec_sql_text(Blocking.most_recent_sql_handle) AS BlockingSQL
CROSS APPLY sys.dm_exec_sql_text(Blocked.sql_handle) AS BlockedSQL
ORDER BY BlockingSessionId, BlockedSessionId

/*
More later....on root cause and before closing here is the best script to find 
what-is-active (successor of SP_WHO2, I say) from fellow MVP Adam Machanic,  
http://sqlblog.com/blogs/adam_machanic/archive/2009/03/30/who-is-active-v8-40-now-with-delta-power.aspx - for your SQL Server 2005 & 2008 instances.
*/