-- Index rename
-- According to pattern:
-- IX_<TableName>_<Col1>_<Col2>...
-- or
-- AK_<TableName>_<Col1>_<Col2>...

-- http://www.sqlservercentral.com/scripts/Indexing/115646/

SELECT
	'EXEC sp_rename ''' + object_schema_name(I.object_id) +'.'+ object_name(I.object_id) +'.' + I.name + ''', ''' +
		CASE WHEN I.is_unique=1 THEN 'AK_' ELSE 'IX_' END +  object_name(I.object_id) + '_'+ I.COLUMN_NAMES
			+ ''', ''index'';'
FROM
(
	SELECT I.object_id, I.index_id, I.name,I.is_primary_key, I.type, I.is_unique, LEFT(I.COLUMN_NAMES,LEN(I.COLUMN_NAMES)-1) AS COLUMN_NAMES
	FROM (
			SELECT I.object_id, I.index_id, I.name,I.is_primary_key, I.type, I.is_unique,
				( SELECT C0.name +'_' AS [text()]
						FROM sys.index_columns IC0
						JOIN sys.columns C0 ON C0.object_id = IC0.object_id AND C0.column_id = IC0.column_id
						WHERE IC0.index_id=I.index_id AND IC0.object_id = I.object_id
						ORDER BY IC0.index_column_id
						FOR XML PATH ('')
				) AS COLUMN_NAMES
			FROM sys.indexes I
			WHERE I.is_primary_key<>1
				AND objectproperty(I.object_id,'IsTable')=1
				AND objectproperty(I.object_id,'IsMSShipped ')=0
				AND I.type NOT IN (0,3) -- Exclude XML indexes and heaps
		) I
) I
WHERE I.name <> CASE WHEN I.is_unique=1 THEN 'AK_' ELSE 'IX_' END +  object_name(I.object_id) + '_'+ I.COLUMN_NAMES
ORDER BY 1
GO