SELECT     
DB_NAME(db.database_id) DatabaseName,     
FORMAT((CAST(mfrows.RowSize AS FLOAT)*8)/1024,'#.00 Mb') RowSizeMB,     
FORMAT((CAST(mflog.LogSize AS FLOAT)*8)/1024,'N','tr-TR') LogSizeMB,
FORMAT((CAST(mfrows.RowSize AS FLOAT)*8)/1024+(CAST(mflog.LogSize AS FLOAT)*8)/1024,'N','tr-TR') DBSizeMB,
FORMAT((CAST(mfrows.RowSize AS FLOAT)*8)/1024/1024+(CAST(mflog.LogSize AS FLOAT)*8)/1024/1024,'N','tr-TR') DBSizeGB
--,(CAST(mfstream.StreamSize AS FLOAT)*8)/1024 StreamSizeMB
--,(CAST(mftext.TextIndexSize AS FLOAT)*8)/1024 TextIndexSizeMB 
FROM sys.databases db     
LEFT JOIN (SELECT database_id, 
                  SUM(size) RowSize 
            FROM sys.master_files 
            WHERE type = 0 
            GROUP BY database_id, type) mfrows 
    ON mfrows.database_id = db.database_id     
LEFT JOIN (SELECT database_id, 
                  SUM(size) LogSize 
            FROM sys.master_files 
            WHERE type = 1 
            GROUP BY database_id, type) mflog 
    ON mflog.database_id = db.database_id     
LEFT JOIN (SELECT database_id, 
                  SUM(size) StreamSize 
                  FROM sys.master_files 
                  WHERE type = 2 
                  GROUP BY database_id, type) mfstream 
    ON mfstream.database_id = db.database_id     
LEFT JOIN (SELECT database_id, 
                  SUM(size) TextIndexSize 
                  FROM sys.master_files 
                  WHERE type = 4 
                  GROUP BY database_id, type) mftext 
    ON mftext.database_id = db.database_id 
       ORDER BY 4 DESC