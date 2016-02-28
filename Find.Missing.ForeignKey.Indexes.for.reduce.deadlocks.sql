SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

;WITH cIndexes
AS (
SELECT i.object_id
,i.name
,(SELECT QUOTENAME(ic.column_id,'(')
FROM sys.index_columns ic
WHERE i.object_id = ic.object_id
AND i.index_id = ic.index_id
AND is_included_column = 0
ORDER BY key_ordinal ASC
FOR XML PATH('')) AS indexed_compare
FROM sys.indexes i
), cForeignKeys
AS (
SELECT fk.name AS foreign_key_name
,'PARENT' as foreign_key_type
,fkc.parent_object_id AS object_id
,STUFF((SELECT ', ' + QUOTENAME(c.name)
FROM sys.foreign_key_columns ifkc
INNER JOIN sys.columns c ON ifkc.parent_object_id = c.object_id AND ifkc.parent_column_id = c.column_id
WHERE fk.object_id = ifkc.constraint_object_id
ORDER BY ifkc.constraint_column_id
FOR XML PATH('')), 1, 2, '') AS fk_columns
,(SELECT QUOTENAME(ifkc.parent_column_id,'(')
FROM sys.foreign_key_columns ifkc
WHERE fk.object_id = ifkc.constraint_object_id
ORDER BY ifkc.constraint_column_id
FOR XML PATH('')) AS fk_columns_compare
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
WHERE fkc.constraint_column_id = 1
UNION ALL
SELECT fk.name AS foreign_key_name
,'REFERENCED' as foreign_key_type
,fkc.referenced_object_id AS object_id
,STUFF((SELECT ', ' + QUOTENAME(c.name)
FROM sys.foreign_key_columns ifkc
INNER JOIN sys.columns c ON ifkc.referenced_object_id = c.object_id AND ifkc.referenced_column_id = c.column_id
WHERE fk.object_id = ifkc.constraint_object_id
ORDER BY ifkc.constraint_column_id
FOR XML PATH('')), 1, 2, '') AS fk_columns
,(SELECT QUOTENAME(ifkc.referenced_column_id,'(')
FROM sys.foreign_key_columns ifkc
WHERE fk.object_id = ifkc.constraint_object_id
ORDER BY ifkc.constraint_column_id
FOR XML PATH('')) AS fk_columns_compare
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
WHERE fkc.constraint_column_id = 1
), cRowCount
AS (
SELECT object_id
,SUM(row_count) AS row_count
FROM sys.dm_db_partition_stats ps
WHERE index_id IN (1,0)
GROUP BY object_id
)
SELECT
'--Missing foreign key index for '+fk.foreign_key_name+CHAR(13)+CHAR(10)+'GO'+CHAR(13)+CHAR(10)+
+'CREATE NONCLUSTERED INDEX FKIX_'+OBJECT_NAME(fk.object_id)+'_'+REPLACE(REPLACE(REPLACE(REPLACE(fk.fk_columns,',',''),'[',''),']',''),' ','')
+CHAR(13)+CHAR(10)+
+'ON [dbo].['+OBJECT_NAME(fk.object_id)+'] ('+fk.fk_columns+')'+CHAR(13)+CHAR(10)+
+'GO'+CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)
FROM cForeignKeys fk
INNER JOIN cRowCount rc ON fk.object_id = rc.object_id
LEFT OUTER JOIN cIndexes i ON fk.object_id = i.object_id AND i.indexed_compare LIKE fk.fk_columns_compare + '%'
WHERE i.name IS NULL
ORDER BY OBJECT_NAME(fk.object_id), fk.fk_columns


