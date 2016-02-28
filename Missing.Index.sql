select distinct 
				DB_NAME(id.database_id) as databaseName,
                id.statement as TableName,
                REPLACE(
					REPLACE(
						id.statement,
						'['+DB_NAME(id.database_id)+'].[dbo].[',
						'')
					,']'
					,'') AS RAWTableName,
				(avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) AS Impact,
					
					
                
                'USE [' + DB_NAME(id.database_id) + '] ' + CHAR(13) + CHAR(10) +
                ';' + CHAR(13) + CHAR(10) +
                'IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'''+id.statement+''') AND name = N'''+
							'IX_' + 
								REPLACE(
									REPLACE(
										id.statement,
										'['+DB_NAME(id.database_id)+'].[dbo].[',
										'')
									,']'
									,'')
							+ '_missing_' 
							+ CAST(id.index_handle AS VARCHAR(10))
						+''')'  + CHAR(13) + CHAR(10) +
				'DROP INDEX ['+
						'IX_' + 
							REPLACE(
								REPLACE(
									id.statement,
									'['+DB_NAME(id.database_id)+'].[dbo].[',
									'')
								,']'
								,'')
						+ '_missing_' 
						+ CAST(id.index_handle AS VARCHAR(10))
					+'] ON '+id.statement+' WITH (ONLINE=OFF)' + CHAR(13) + CHAR(10) +
				';' + CHAR(13) + CHAR(10) +
                'CREATE NONCLUSTERED INDEX IX_' + 
					REPLACE(
						REPLACE(
							id.statement,
							'['+DB_NAME(id.database_id)+'].[dbo].[',
							'')
						,']'
						,'')
                + '_missing_' 
				+ CAST(id.index_handle AS VARCHAR(10))
				+ ' On ' + id.STATEMENT 
				+ ' (' + IsNull(id.equality_columns,'') 
				+ CASE WHEN id.equality_columns IS Not Null 
					And id.inequality_columns IS Not Null THEN ',' ELSE '' END 
				+ IsNull(id.inequality_columns, '')
				+ ')' 
				+ IsNull(' Include (' + id.included_columns + ')', '')  + CHAR(13) + CHAR(10) 
				+ ';' + CHAR(13) + CHAR(10) 
				AS sql_statement
                ,
				
				
				/* 
                'CREATE NONCLUSTERED INDEX IX_'+
                REPLACE(
					REPLACE(
						id.statement,
						'['+DB_NAME(id.database_id)+'].[dbo].[',
						'')
					,']'
					,'')
                +'_' +
				CAST((ROW_NUMBER() OVER (ORDER BY avg_total_user_cost * avg_user_impact * (user_seeks + user_scans)/100 desc)) AS VARCHAR) + 
				' ON '+id.statement+'(' + id.equality_columns + ');' strsql,
				--' ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] (' + id.equality_columns + ');' strsql,
				*/
				
				
				id.equality_columns,
                id.inequality_columns,
                id.included_columns,
                gs.last_user_seek,
                gs.user_seeks,
                gs.last_user_scan,
                gs.user_scans,
                gs.avg_total_user_cost * gs.avg_user_impact * (gs.user_seeks + gs.user_scans)/100 as ImprovementValue                
                
                
from sys.dm_db_missing_index_group_stats gs
INNER JOIN sys.dm_db_missing_index_groups ig on gs.group_handle = ig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details id on id.index_handle = ig.index_handle
where DB_NAME(id.database_id) = 'GulaylarOnlineDb'

order by avg_total_user_cost * avg_user_impact * (user_seeks + user_scans)/100 desc

                




/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
/*
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE NONCLUSTERED INDEX IX_Urunler ON dbo.Urunler
	(
	SinifAdi,
	AltSinifAdi,
	Aktif,
	KurKodu
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Urunler SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


DBCC CHECKDB
*/


/*
-- INDEX leri tekrar oluþturup düzenleyen komut
DBCC DBREINDEX('dbo.Urunler');
GO

-- DBCC DBREINDEX komutu offline çalýþýyor, onun yerine bunu çalýþtýrýrsak online çalýþýyor
-- Ama sadece enterprice edition da çalýþýyor
ALTER INDEX ALL ON dbo.Urunler
REBUILD WITH (ONLINE = ON, FILLFACTOR = 90)
*/