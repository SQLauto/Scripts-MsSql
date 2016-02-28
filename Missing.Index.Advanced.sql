Use Ykb_recycle
GO

SELECT  sys.objects.name
, (avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) AS Impact
,  'CREATE NONCLUSTERED INDEX IX_'+ sys.objects.name COLLATE DATABASE_DEFAULT + '_' +
		CAST(RIGHT(YEAR(GETDATE()),2) AS NVARCHAR(MAX)) + 
		+  CAST(RIGHT(100 + DATEPART(MONTH,GETDATE()),2) AS NVARCHAR(MAX)) + 
		+  CAST(RIGHT(100 + DATEPART(DAY,GETDATE()),2) AS NVARCHAR(MAX)) + 
		+  CAST(RIGHT(100 + DATEPART(HOUR,GETDATE()),2) AS NVARCHAR(MAX)) + 
		+  CAST(RIGHT(100 + DATEPART(MINUTE,GETDATE()),2) AS NVARCHAR(MAX)) + 
		+  CAST(RIGHT(100 + DATEPART(SECOND,GETDATE()),2) AS NVARCHAR(MAX)) + '_'
		+  CAST(ROUND(((99999 - 1001 -1) * RAND() + 1001), 0) + (ABS(CAST(NEWID() AS binary(6)) %1000) + 1)  AS NVARCHAR(MAX)) +
		
		--+  CAST(RIGHT(100 + DATEPART(MILLISECOND,GETDATE()),2) AS NVARCHAR(MAX)) + 
		--+  CAST(RIGHT(100 + DATEPART(MICROSECOND,GETDATE()),2) AS NVARCHAR(MAX)) +
		--+  CAST(RIGHT(100 + DATEPART(NANOSECOND,GETDATE()),2) AS NVARCHAR(MAX)) +
		' ON ' + sys.objects.name COLLATE DATABASE_DEFAULT + ' ( ' + IsNull(mid.equality_columns, '') + CASE WHEN mid.inequality_columns IS NULL 
                THEN ''  
    ELSE CASE WHEN mid.equality_columns IS NULL 
                    THEN ''  
        ELSE ',' END + mid.inequality_columns END + ' ) ' + CASE WHEN mid.included_columns IS NULL 
                THEN ''  
    ELSE 'INCLUDE (' + mid.included_columns + ')' END + ';' AS CreateIndexStatement
, mid.equality_columns
, mid.inequality_columns
, mid.included_columns 
    FROM sys.dm_db_missing_index_group_stats AS migs 
            INNER JOIN sys.dm_db_missing_index_groups AS mig ON migs.group_handle = mig.index_group_handle 
            INNER JOIN sys.dm_db_missing_index_details AS mid ON mig.index_handle = mid.index_handle AND mid.database_id = DB_ID() 
            INNER JOIN sys.objects WITH (nolock) ON mid.OBJECT_ID = sys.objects.OBJECT_ID 
    WHERE     (migs.group_handle IN 
        ( 
        SELECT     TOP (500) group_handle 
            FROM          sys.dm_db_missing_index_group_stats WITH (nolock) 
            ORDER BY (avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) DESC))  
        AND OBJECTPROPERTY(sys.objects.OBJECT_ID, 'isusertable')=1 
    ORDER BY 1,2 DESC , 3 DESC 



/*

CREATE NONCLUSTERED INDEX IX_history_base_151015152504_23105 ON history_base ( [atm_id],[history_date], [cash_in], [cash_out] ) INCLUDE ([object_id], [transfer_in], [transfer_out], [known_in], [known_out], [closing_in], [closing_out], [openning_in], [openning_out], [is_cash_out], [is_vault_full], [currency], [closing_r]);

*/