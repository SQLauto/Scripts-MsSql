/* Missing index e neden olan scriptleri bulmak için */
--Use GulaylarOnlineDb;

select
     st.[text],
     SUBSTRING(st.text, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         ELSE qs.statement_end_offset
         END - qs.statement_start_offset)/2) + 1) AS statement_text,       
     qs.last_execution_time,
     qs.execution_count,
     qs.total_logical_reads as total_logical_read,
     qs.total_logical_reads/execution_count as avg_logical_read,
     qs.total_worker_time/1000000 as total_cpu_time_sn,
     qs.total_worker_time/qs.execution_count/1000 as avg_cpu_time_ms,
     qp.query_plan,
     qs.last_logical_reads,
     qs.plan_generation_num
from sys.dm_exec_query_stats qs
cross apply sys.dm_exec_sql_text(qs.sql_handle) st 
cross apply sys.dm_exec_query_plan(qs.plan_handle) qp
where SUBSTRING(st.text, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         ELSE qs.statement_end_offset
         END - qs.statement_start_offset)/2) + 1) like '%Urunler%'
