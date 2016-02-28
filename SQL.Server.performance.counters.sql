/*
https://www.simple-talk.com/sql/performance/a-performance-troubleshooting-methodology-for-sql-server/

The performance counters collected by this script are:

SQLServer:Access Methods\Full Scans/sec
SQLServer:Access Methods\Index Searches/sec
SQLServer:Buffer Manager\Lazy Writes/sec
SQLServer:Buffer Manager\Page life expectancy
SQLServer:Buffer Manager\Free list stalls/sec
SQLServer:General Statistics\Processes Blocked
SQLServer:General Statistics\User Connections
SQLServer:Locks\Lock Waits/sec
SQLServer:Locks\Lock Wait Time (ms)
SQLServer:Memory Manager\Memory Grants Pending
SQLServer:SQL Statistics\Batch Requests/sec
SQLServer:SQL Statistics\SQL Compilations/sec
SQLServer:SQL Statistics\SQL Re-Compilations/sec
The two Access Methods counters provide information about the ways that tables are being accessed in the database. The most important one is the Full Scans/sec counter, which can give us an idea of the number of index and table scans that are occurring in the system.

If the disk I/O subsystem is the bottleneck (which, remember, is most often caused by pressure placed on it by a problem elsewhere) and this counter is showing that there are scans occurring, it may be a sign that there are missing indexes, or inefficient code in the database. How many scans are problematic? It depends entirely on the size of the objects being scanned and the type of workload being run. In general, I want the number of Index Searches/sec to be higher than the number of Full Scans/sec by a factor of 800–1000. If the number of Full Scans/sec is too high, I use the Database Engine Tuning Advisor (DTA) or the Missing Indexes feature to determine if there are missing indexes in the database, resulting in excess I/O operations.

The Buffer Manager and Memory Manager counters can be used, as a group, to identify if SQL Server is experiencing memory pressure. The values of the Page Life Expectancy, Free List Stalls/sec, and Lazy Writes/sec counters, when correlated, will validate or disprove the theory that the buffer cache is under memory pressure.

A lot of online references will tell you that if the Page Life Expectancy (PLE) performance counter drops lower than 300, which is the number of seconds a page will remain in the data cache, then you have memory pressure. However, this guideline value for the PLE counter was set at a time when most SQL Servers only had 4 GB of RAM, and the data cache portion of the buffer pool was generally 1.6 GB. In modern servers, where it is common for SQL Servers to have 32 GB or more of installed RAM, and a significantly larger data cache, having 1.6 GB of data churn through that cache every 5 minutes is not necessarily a significant event.

In short, the appropriate value for this counter depends on the size of the SQL Server data cache, and a fixed value of 300 no longer applies. Instead, I evaluate the value for the PLE counter based on the installed memory in the server. To do this, I take the base counter value of 300 presented by most resources, and then determine a multiple of this value based on the configured buffer cache size, which is the 'max server memory' sp_configure option in SQL Server, divided by 4 GB. So, for a server with 32 GB allocated to the buffer pool, the PLE value should be at least (32/4)*300 = 2400.

If the PLE is consistently below this value, and the server is experiencing high Lazy Writes/sec, which are page flushes from the buffer cache outside of the normal CHECKPOINT process, then the server is most likely experiencing data cache memory pressure, which will also increase the disk I/O being performed by the SQL Server. At this point, the Access Methods counters should be investigated to determine if excessive table or index scans are being performed on the SQL Server.

The General Statistics\Processes Blocked, Locks\Lock Waits/sec, and Locks\Lock Wait Time (ms) counters provide information about blocking in the SQL Server instance, at the time of the data collection. If these counters return a value other than zero, over repeated collections of the data, then blocking is actively occurring in one of the databases and we can use tools such as the Blocked Process Report in SQL Trace, or the sys.dm_exec_requests, sys.dm_exec_sessions and sys.dm_os_waiting_tasks DMVs to troubleshoot the problems further.

The three SQL Statistics counters provide information about how frequently SQL Server is compiling or recompiling an execution plan, in relation to the number of batches being executed against the server. The higher the number of SQL Compilations/sec in relation to the Batch Requests/sec, the more likely the SQL Server is experiencing an ad hoc workload that is not making optimal using of plan caching. The higher the number of SQL Re-Compilations/sec in relation to the Batch Requests/sec, the more likely it is that there is an inefficiency in the code design that is forcing a recompile of the code being executed in the SQL Server. In either case, investigation of the Plan Cache, as detailed in the next section, should identify why the server has to consistently compile execution plans for the workload.

The Memory Manager\Memory Grants Pending performance counter provides information about the number of processes waiting on a workspace memory grant in the instance. If this counter has a high value, SQL Server may benefit from additional memory, but there may be query inefficiencies in the instance that are causing excessive memory grant requirements, for example, large sorts or hashes that can be resolved by tuning the indexing or queries being executed.

*/


DECLARE @CounterPrefix NVARCHAR(30)
SET @CounterPrefix = CASE
    WHEN @@SERVICENAME = 'MSSQLSERVER'
    THEN 'SQLServer:'
    ELSE 'MSSQL$'+@@SERVICENAME+':'
    END;


-- Capture the first counter set
SELECT CAST(1 AS INT) AS collection_instance ,
      [OBJECT_NAME] ,
      counter_name ,
      instance_name ,
      cntr_value ,
      cntr_type ,
      CURRENT_TIMESTAMP AS collection_time
INTO #perf_counters_init
FROM sys.dm_os_performance_counters
WHERE ( OBJECT_NAME = @CounterPrefix+'Access Methods'
         AND counter_name = 'Full Scans/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Access Methods'
           AND counter_name = 'Index Searches/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Buffer Manager'
           AND counter_name = 'Lazy Writes/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Buffer Manager'
      AND counter_name = 'Page life expectancy'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'General Statistics'
           AND counter_name = 'Processes Blocked'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'General Statistics'
           AND counter_name = 'User Connections'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Locks'
           AND counter_name = 'Lock Waits/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Locks'
           AND counter_name = 'Lock Wait Time (ms)'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'SQL Statistics'
           AND counter_name = 'SQL Re-Compilations/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Memory Manager'
           AND counter_name = 'Memory Grants Pending'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'SQL Statistics'
           AND counter_name = 'Batch Requests/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'SQL Statistics'
           AND counter_name = 'SQL Compilations/sec'
)

-- Wait on Second between data collection
WAITFOR DELAY '00:00:01'

-- Capture the second counter set
SELECT CAST(2 AS INT) AS collection_instance ,
       OBJECT_NAME ,
       counter_name ,
       instance_name ,
       cntr_value ,
       cntr_type ,
       CURRENT_TIMESTAMP AS collection_time
INTO #perf_counters_second
FROM sys.dm_os_performance_counters
WHERE ( OBJECT_NAME = @CounterPrefix+'Access Methods'
      AND counter_name = 'Full Scans/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Access Methods'
           AND counter_name = 'Index Searches/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Buffer Manager'
           AND counter_name = 'Lazy Writes/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Buffer Manager'
           AND counter_name = 'Page life expectancy'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'General Statistics'
           AND counter_name = 'Processes Blocked'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'General Statistics'
           AND counter_name = 'User Connections'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Locks'
           AND counter_name = 'Lock Waits/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Locks'
           AND counter_name = 'Lock Wait Time (ms)'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'SQL Statistics'
           AND counter_name = 'SQL Re-Compilations/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'Memory Manager'
           AND counter_name = 'Memory Grants Pending'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'SQL Statistics'
           AND counter_name = 'Batch Requests/sec'
      )
      OR ( OBJECT_NAME = @CounterPrefix+'SQL Statistics'
           AND counter_name = 'SQL Compilations/sec'
)

-- Calculate the cumulative counter values
SELECT  i.OBJECT_NAME ,
        i.counter_name ,
        i.instance_name ,
        CASE WHEN i.cntr_type = 272696576
          THEN s.cntr_value - i.cntr_value
          WHEN i.cntr_type = 65792 THEN s.cntr_value
        END AS cntr_value
FROM #perf_counters_init AS i
  JOIN  #perf_counters_second AS s
    ON i.collection_instance + 1 = s.collection_instance
      AND i.OBJECT_NAME = s.OBJECT_NAME
      AND i.counter_name = s.counter_name
      AND i.instance_name = s.instance_name
ORDER BY OBJECT_NAME

-- Cleanup tables
DROP TABLE #perf_counters_init
DROP TABLE #perf_counters_second 
