--USE Test_Cash_Branch
GO
-- Bundan sonra "update db stats.sql" çalýþtýrmayý unutma
-- KOMUT: exec sp_updatestats
SELECT
	stats.object_id AS objectid,
	QUOTENAME(o.name) AS objectname,
	QUOTENAME(s.name) AS schemaname,
	stats.index_id AS indexid,
	i.name AS index_name,
	stats.partition_number AS partitionnum,
	stats.avg_fragmentation_in_percent AS frag,
	stats.page_count,
	CASE 
	when stats.avg_fragmentation_in_percent < 30 then 'ALTER INDEX [' + i.name + '] ON ' +o.name +' REORGANIZE'

	when stats.avg_fragmentation_in_percent > 30 then 'ALTER INDEX [' + i.name + '] ON ' +o.name +' REBUILD'
	END AS 'action_to_take'
	FROM 
	sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL , NULL, 'LIMITED') as stats,
	sys.objects AS o,
	sys.schemas AS s,
	sys.indexes AS i
WHERE 
o.object_id = stats.object_id
AND
s.schema_id = o.schema_id 
AND
i.object_id = stats.object_id
AND
i.index_id = stats.index_id
AND
stats.avg_fragmentation_in_percent > 20.0 

AND 
stats.index_id > 0
ORDER BY
objectname
